fs = require 'fs'
path = require 'path'
async = require 'async'

hljs = require "highlight.js"
modelist = require "../../utils/modelist"

class Code
  constructor: (@options) ->
    @hbs = @options.hbs
    @lang = @options.hash.lang
    @root = @options.root

  # @param path {Path} optional. The path to read piece of code from. Relative to project root.
  #
  # If path is not given, the block should yield the source code.
  process: (inputPath,cb) ->
    if !cb
      cb = inputPath
      @path = null
    else
      @path = inputPath

    async.waterfall [
      (cb) =>
        if @path
          fs.readFile path.join(@root,@path),{encoding: "utf8"}, cb
        else
          source = @options.fn()
          cb(null,source)
      (source,cb) =>
        source = @prepareSource(source)
        html = "<pre><code>#{source}</code></pre>"
        cb(null,@hbs.safe(html))
    ], cb

  # Return the source code as html content. Highlight it there's a match highlighter.
  # @return (HTML)
  prepareSource: (source) ->
    if @lang
      lang = @lang
    else if @path
      lang = @guessLanguageName(@path)
    else
      lang = null

    if lang
      code = @highlight(lang,source)
    else
      code = @hbs.escape source

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

