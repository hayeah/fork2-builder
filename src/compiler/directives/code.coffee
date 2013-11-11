fs = require 'fs'
path = require 'path'
async = require 'async'

hljs = require "highlight.js"
modelist = require "../../utils/modelist"

class Code
  constructor: (@path,@options) ->
    @hbs = @options.hbs

  process: (cb) ->
    async.waterfall [
      (cb) => fs.readFile @path,{encoding: "utf8"}, cb
      (source,cb) =>
        source = @prepareSource(source)
        html = "<pre><code>#{source}</code></pre>"
        cb(null,@hbs.safe(html))
    ], cb

  # Return the source code as html content. Highlight it there's a match highlighter.
  # @return (HTML)
  prepareSource: (source) ->
    if lang = @languageName(@path)
      code = @highlight(lang,source)
    else
      code = @hbs.escape source

  # Uses ace editor's modelist to guess language name from a given filename.
  # @return (String|null) the language name, or null if there's no associated mode.
  languageName: (path) ->
    match = modelist.getModeForPath(path)

    if match.name == "text"
      return null

    return match.name

  highlight: (lang,code) ->
    hljs.highlight(lang,code).value




module.exports = Code

