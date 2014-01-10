marked = require 'marked'

# highlight = require "./highlight"
async = require 'async'
sync = require 'sync'
hbs = require("handlebars")
_s = require "underscore.string"

SourceFormatter = require "./source-formatter"

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

# TODO: refactor this to be a separate file
directives =
  code: buildHelper("./directives/code")
  prompt: buildHelper("./directives/prompt")
  aside: buildHelper("./directives/aside")
  md: markdown
  markdown: markdown
  footnote: buildHelper("./directives/footnote")
  margin: buildHelper("./directives/margin")
  tag: buildHelper("./directives/tag")
  "quiz-choose-many": buildHelper("./directives/quiz-choose-many")
  "quiz-input": buildHelper("./directives/quiz-input")
  img: buildHelper("./directives/img")
  play: buildHelper("./directives/play")

TRANSFORMERS = [
  require("./directives/footnote").transform
]

class TemplateCompiler
  constructor: (@root) ->
    # for directives to put data
    @data = {}

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

  # @param {String} input The string to compile as template
  # @param {Function(Error,String)} Callbacks with the compiled output string.
  compile: (input,cb) ->
    async.waterfall [
      @renderhbs.bind(@,input)
      (input,cb) =>
        sync (=>
          @renderMarkedDown(input)
        ), cb
      @applyTransforms.bind(@)
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

  # apply a series of input transform
  # Each transformer is a simple string -> string function.
  # TODO: change the contract to through pipes.
  applyTransforms: (input,cb) ->
    pipe = async.compose.apply(@,TRANSFORMERS)
    pipe(this,input,cb)

  renderMarkedDown: (input) ->
    renderer = new marked.Renderer()
    idfy = (str) -> _s.dasherize(str.toLowerCase())
    renderer.header = (text,level) ->
      "<h#{level} id='#{idfy(text)}'>#{text}</h#{level}>"
    renderer.blockcode = (code,lang) =>

      formatter = new SourceFormatter(code,lang)
      process = (cb) ->
        formatter.format({},cb)

      result = process.sync()
      # console.log "md-code", result
      @hbs.safe result

    marked input, {
      renderer: renderer
    }

module.exports = TemplateCompiler
