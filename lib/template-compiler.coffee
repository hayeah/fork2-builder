marked = require 'marked'
async = require 'async'
sync = require 'sync'

hbs = require("handlebars")

markdown = (options) ->
  input = options.fn(this)
  
  # sync version
  # output = marked(input)

  # async version
  render = (cb) ->
    marked input, {}, cb

  output = render.sync(null)

class TemplateCompiler
  constructor: (@inStream,@outStream,@root) ->
    @hbs = hbs.create()
    @hbs.registerHelper("markdown",markdown)
    @hbs.registerHelper("md",markdown)

  # cb(err)
  compile: (cb) ->
    async.waterfall [
      @readInput.bind(@)
      @renderhbs.bind(@)
      @writeOutput.bind(@)
    ], cb

  # @param content (String)
  # cb(err,renderResult:String)
  renderhbs: (content,cb) ->
    context = {}
    template = @hbs.compile(content)
    # Because handlebarjs does not support helpers that uses async functions,
    # we use the sync library here so helper functions can use fiber to make
    # an async function to behave as though it is synchronous to handlebarjs.
    sync (->
      body = template(context)
    ), cb

  # cb(err,streamData:String)
  readInput: (cb) ->
    chunks = []
    @inStream.on "data", (data) ->
      # assume is a buffer
      # TODO type check
      chunks.push data.toString()
    @inStream.on "end", ->
      cb(null,chunks.join(""))
    @inStream.on "error", (error) ->
      cb(error)

  # @param result (String)
  # cb(err)
  writeOutput: (result,cb) ->
    @outStream.write(result,"utf8",cb)

module.exports = TemplateCompiler