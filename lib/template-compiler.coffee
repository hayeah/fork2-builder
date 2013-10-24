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

# Add the root parameter to helper options when it is invoked.
# @param root (Path) the root path for template compilation
# @return The wrapped helper function
withRoot = (fn,root) ->
  return ->
    args = arguments
    options = args[args.length-1]
    options.root = root
    fn.apply(this,args)

path = require 'path'
Code = require './directives/code'
code = (filepath,options) ->
  fullpath = path.join(options.root,filepath)
  processor = new Code(fullpath)
  processor.process.sync(processor)

class TemplateCompiler
  constructor: (@inStream,@outStream,@root) ->
    @hbs = hbs.create()
    @register("markdown",markdown)
    @register("md",markdown)
    @register("code",code)

  # Registers a function as handlebars helper. Also injects the
  # root context of the TemplateCompiler into the `options` argument when 
  # the helper is invoked.
  register: (name,fn) ->
    @hbs.registerHelper(name,withRoot(fn,@root))

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