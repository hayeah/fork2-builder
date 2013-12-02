marked = require 'marked'
hljs = require "highlight.js"

async = require 'async'
sync = require 'sync'
hbs = require("handlebars")

# Add the root parameter to helper options when it is invoked.
# @param root (Path) the root path for template compilation
# @param hbs (Handlebars) the instance of handlebars.js doing compilation
# @return The wrapped helper function
withRoot = (fn,vars) ->
  return ->
    args = arguments
    options = args[args.length-1]
    for key,val of vars
      options[key] = val
    fn.apply(this,args)

# Build a synchronous handlebars helper function from a directive class
buildHelper = (mod) ->
  klass = require(mod)
  return ->
    args = Array.prototype.slice.call(arguments,0)
    options = args[args.length-1]

    # initialize an instance of the directive with options
    directive = new klass(options)

    # remove options from process args
    process_args = args[0...args.length-1]
    process = (cb) ->
      process_args.push(cb)
      directive.process.apply(directive,process_args)

    process.sync()

# edit = buildHelper("./directives/edit")
markdown = buildHelper("./directives/markdown")
footnote =

# TODO: refactor this to be a separate file
directives =
  code: buildHelper("./directives/code")
  md: markdown
  markdown: markdown
  footnote: buildHelper("./directives/footnote")
  margin: buildHelper("./directives/margin")
  tag: buildHelper("./directives/tag")

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
    @hbs.registerHelper(name,withRoot(fn,{root: @root,hbs: @hbs, compiler: this}))

  # cb(err)
  compile: (cb) ->
    async.waterfall [
      @readInput.bind(@)
      @renderhbs.bind(@)
      @appendTails.bind(@)
      @renderMarkedDown.bind(@)
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

  # Add a markdown string to be appended at the end.
  appendToEnd: (string) ->
    @_appendedTexts ||= []
    @_appendedTexts.push string

  # render the delayed output to the end of rendered handlebars template.
  appendTails: (input,cb) ->
    output =
      if @_appendedTexts
        tail = @_appendedTexts.join("\n")
        "#{input}\n#{tail}"
      else
        input
    cb(null,output)

  renderMarkedDown: (input,cb) ->
    marked input, {
      highlight:  (code, lang) ->
        hljs.highlight(lang, code).value
      }, cb

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
