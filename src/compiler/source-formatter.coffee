pygmentize = require "pygmentize-bundled"
cheerio = require "cheerio"
async = require 'async'
_ = require 'lodash'

TaggedSource = require "./tagged-source"

# Transform a tagged source to html output.
#
# Decorations are processing instructions that does
#
# + filtering
# + line highlighting
# + annotation
#
# Finally for html output, the formatter does
#
# + syntax coloring
# + removing empty tagged lines
#
# Implementation notes
#
# It should only strip empty tag lines at the very end of formatting

# @property $ {Function} query object for the DOM of the syntax colored @cleanSource
class SourceFormatter
  constructor: (@code,@lang) ->
    # hmm. I think annotation and highlighting should just set properties on string objects.
    # tagged source track data that are associated with original line numbers.
    # @source.set(addr,"highlighted",true)
    # @source.set(addr,"annotation",note)

    # taggedsource for manipulation
    @taggedSource = new TaggedSource(@code)

    # source with tags removed.
    @cleanSource = @taggedSource.lines.join("\n")

    # add annotation
    @annotation

    # add highlight
    @highlight

    # filter lines by destructively removing lines from @dom

    # dom to html string

    # filter: (cmd,addr) ->

    # annotate: (addr,content) ->

    # highlight: (addr,klass="code-highlight") ->


  format: (decorators,cb) ->
    async.waterfall [
      @initDOM.bind(@)
      (cb) =>
        @highlight(decorators["highlight"] || [])
        @filter(decorators["filter"] || ["all"])
        @normalizeDOM()
        cb(null)
      (cb) =>
        cb(null,@$.html())
    ], cb

  # Sets @$ to the DOM representation of highlighed code
  initDOM: (cb) ->
    @colorSyntax (err,html) =>
      if err
        cb(err)
        return
      @$ = cheerio.load(html)
      cb(null)

  $wrapper: ->
    @$("root > div")

  $lines: ->
    @$("pre > span")

  $line: (i) ->
    @$(@$lines()[i])

  # pygmentize -f html -P classprefix=pyg- -P full=True  -P linespans=line  doc/template-examples/code/example.rb
  colorSyntax: (cb) ->
    pygmentize {
      lang: @lang
      format: "html"
      options: {
        classprefix: "pyg-"
        linespans: "ln"
        # nowrap: "True"
      }
    }, @cleanSource, (err,output) ->
      if err
        cb(err)
      else
        cb(null,String(output))


  # Pluck out sources using tags. Will also remove source tags.
  # @callback {[Error,String]}
  filter: (commands) ->
    source = @taggedSource
    source.selectNone()

    for command in commands
      if command == "all"
        source.selectAll()
      else if command == "none"
        source.selectNone()
      else if addr = command.add
        source.select(addr)
      else if addr = command.del
        source.deselect(addr)
      else
        throw "unknown filter command: #{command}"

    lines = source.getOutputLines()
    allLines = [0...source.lines.length]
    delLines = _.difference(allLines,lines)

    # console.log "all-lines", allLines
    # console.log "selected", lines
    # console.log "remove", delLines

    for i in delLines
      $line = @$("#ln-#{i+1}") # pygment's numbering starts at 1
      $line.remove()

    return

  highlight: (commands) ->
    source = @taggedSource
    source.selectNone()

    for command in commands
      if command == "none"
        source.selectNone()
      else if addr = command.add
        source.select(addr)
      else if addr = command.del
        source.deselect(addr)
      else
        throw "unknown filter command: #{command}"

    # console.log "hl", source.selectedLines
    for i in source.selectedLines
      $line = @$line(i)
      $line.addClass("pyg-hll")

  # final pass before output
  normalizeDOM: () ->
    for line in @$lines()
      $line = @$(line)
      id = $line.attr("id")
      $line.removeAttr("id")
      lineno = id.split("-")[1]
      $line.attr("data-line",lineno)
      tag = $line[0]
      tag.name = "div"

    div = @$wrapper()
    div.removeClass("highlight")
    div.addClass("pyg-code")

    return


module.exports = SourceFormatter

