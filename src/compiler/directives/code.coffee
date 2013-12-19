fs = require 'fs'
path = require 'path'
async = require 'async'
yaml = require 'js-yaml'
Handlebars = require "handlebars"

Base = require "./base"
highlight = require "../highlight"
modelist = require "../../utils/modelist"
SourceFormatter = require "../source-formatter"

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
      @formatSource.bind(@)
      @prepareHTML.bind(@)
    ], cb

  readSource: (filePath,cb) ->
    fs.readFile filePath,{encoding: "utf8"}, cb

  # @callback {[Error,String]}
  formatSource: (input,cb) ->
    lang = @guessLanguageName(@path)
    formatter = new SourceFormatter(input,lang)
    formatter.format @decorators,cb

  highlightSource: (input, cb) ->

  prepareHTML: (input,cb) ->
    cb null, @safe("<pre><code>#{input}</code></pre>")

  # # Uses ace editor's modelist to guess language name from a given filename.
  # # @return (String|null) the language name, or null if there's no associated mode.
  guessLanguageName: (path) ->
    match = modelist.getModeForPath(path)

    if match.name == "text"
      return null

    return match.name

module.exports = Code

