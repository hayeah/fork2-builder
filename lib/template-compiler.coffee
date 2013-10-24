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
# @param hbs (Handlebars) the instance of handlebars.js doing compilation
# @return The wrapped helper function
withRoot = (fn,root,hbs) ->
  return ->
    args = arguments
    options = args[args.length-1]
    options.root = root
    options.hbs = hbs
    fn.apply(this,args)

path = require 'path'
Code = require './directives/code'
code = (filepath,options) ->
  fullpath = path.join(options.root,filepath)
  processor = new Code(fullpath,options)
  processor.process.sync(processor)

# TODO: refactor this to be a separate file
directives = 
  code: code
  md: markdown
  markdown: markdown

class TemplateCompiler
  constructor: (@inStream,@outStream,@root) ->
    @hbs = hbs.create()
    
    # Add utility functions to this instance of handlebars
    #
    # returns html safe string
    @hbs.escape = (str) => 
      @hbs.Utils.escapeExpression(str)

    # mark a string as not to escape
    @hbs.safe = (str) =>
      new @hbs.SafeString(str)

    for name, fn of directives
      @register(name,fn)

  # Registers a function as handlebars helper. Also injects the
  # root context of the TemplateCompiler into the `options` argument when 
  # the helper is invoked.
  register: (name,fn) ->
    @hbs.registerHelper(name,withRoot(fn,@root,@hbs))

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
      try
        body = template(context)
      catch e
        console.log e
        console.log e.stack
        throw e
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