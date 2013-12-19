fs = require 'fs'
path = require 'path'
async = require 'async'
yaml = require 'js-yaml'
Handlebars = require "handlebars"

Base = require "./base"
highlight = require "../highlight"
modelist = require "../../utils/modelist"
TaggedSource = require "../tagged-source"

template = Handlebars.compile """
{{data}}
"""

class Code extends Base
  # @param filepath {Path} The path to read piece of code from. Relative to project root.
  process: (filepath,cb) ->
    unless typeof filepath == "string"
      cb("no path is given to read source code from.")
      return

    # path to read code source from.
    @path = path.join @root, "code", filepath

    if yamlData = @contentString()
      @decorators = yaml.safeLoad(yamlData)
    else
      @decorators = {}

    # console.log "decorators", @decorators

    async.waterfall [
      @readSource.bind(@,@path)
      @filterSource.bind(@)
      @prepareHTML.bind(@)
    ], cb

  readSource: (filePath,cb) ->
    fs.readFile filePath,{encoding: "utf8"}, cb

  # Pluck out sources using tags. Will also remove source tags.
  # @callback {[Error,String]}
  filterSource: (input,cb) ->
    filter = @decorators["filter"]
    filter ||= []

    source = new TaggedSource(input)
    # console.log source.tags
    for command in filter
      if command == "none"
        source.selectNone()
      else if addr = command.add
        source.select(addr)
      else if addr = command.del
        source.deselect(addr)
      else
        throw "unknown filter command: #{command}"

    cb(null,source.getOutput())

  #
  highlightSource: (input, cb) ->

  prepareHTML: (input,cb) ->
    cb null, @safe("<pre><code>#{input}</code></pre>")

  # # Uses ace editor's modelist to guess language name from a given filename.
  # # @return (String|null) the language name, or null if there's no associated mode.
  # guessLanguageName: (path) ->
  #   match = modelist.getModeForPath(path)

  #   if match.name == "text"
  #     return null

  #   return match.name

module.exports = Code

