fs = require 'fs'
path = require 'path'
async = require 'async'

highlight = require "../highlight"
modelist = require "../../utils/modelist"

class Code
  constructor: (@options) ->
    @hbs = @options.hbs
    @lang = @options.hash.lang
    @root = @options.root

  # @param filepath {Path} The path to read piece of code from. Relative to project root.
  process: (filepath,cb) ->
    @path = filepath
    if !(@path and cb)
      throw "no path is given to read source code from."
      return
    async.waterfall [
      (cb) =>
        fs.readFile path.join(@root,@path),{encoding: "utf8"}, cb
      (source,cb) =>
        source = @prepareSource(source)
        # the span wrapper is used to measure the width of the code block
        html = "<pre><code><span>#{source}</span></code></pre>"
        cb(null,@hbs.safe(html))
    ], cb

  # Return the source code as html content. Highlight it there's a match highlighter.
  # @return (HTML)
  prepareSource: (code) ->
    if @lang
      lang = @lang
    else if @path
      lang = @guessLanguageName(@path)
    else
      lang = null

    highlight(code,lang,@hbs)

  # Uses ace editor's modelist to guess language name from a given filename.
  # @return (String|null) the language name, or null if there's no associated mode.
  guessLanguageName: (path) ->
    match = modelist.getModeForPath(path)

    if match.name == "text"
      return null

    return match.name

  highlight: (lang,code) ->
    hljs.highlight(lang,code).value




module.exports = Code

