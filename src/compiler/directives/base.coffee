marked = require 'marked'
yaml = require "js-yaml"

class Base
  # @param options {Hash} The options object given to a mustache helper.
  # @param options.root {Path} The project root.
  # @param options.hbs {Path} The Handlebars instance used to render this template.
  constructor: (@options) ->
    @compiler = @options.compiler
    @hbs = @options.hbs
    @root = @options.root
    # Is this directive being invoked as a block helper?
    @isBlock = !!@options.fn
    @hash = @options.hash

  # Returns the block content as raw string. If given an object, use that
  # object as the context for the block content.
  #
  # @return {String}
  contentString: (context={}) ->
    if fn = @options.fn
      fn(context || this)

  ###
  Splits block content into sections seperated by the divider "\n---\n"
  @return {[String]}
  ###
  splitSections: ->
    @contentString().split("\n---\n")

  ###
  Splits block content into text content and yaml trailer data. Returns raw
  content string and the parsed trailer yaml as data.

  The format looks like:

  {{#some-tag}}
  tag block content
  ---
  yaml data
  {{/some-tag}}
  ###
  # @return {[String,YamlObject]}
  splitContentTrailerData: ->
    [content, yamlstring] = @splitSections()
    return [content, yaml.safeLoad(yamlstring)]

  # Recursively render the block content as template.
  # @param {String} contentString the template to render.
  # @return {HTMLString}
  renderContentString: (contentString,context={}) ->
    template = @hbs.compile(contentString)
    hbsOutput = template(context)
    marked(hbsOutput,{})

  # Returns the block content as rendered template.
  # @return {HTMLString}
  content: (context={}) ->
    content = @contentString()
    renderContentString(content,context)

  # Escapes a string to make it HTML safe. See note on `safe` about marking
  # a string as safe.
  escape: (str) ->
    @hbs.escape(str)

  # Marks a string as HTML safe.
  #
  # NOTE hbs tests if a string needs escaping by testing whether it is an instance of
  # a SafeString specific the the current instance of handlebars. This is why we need
  # to proxy the safe string factory via the particular instance of handlebars we are using
  # instead of the default handlebars instance.
  safe: (str) ->
    @hbs.safe(str)

  # Delay outputing a markdown string until the end
  appendToEnd: (str) ->
    @compiler.appendToEnd(str)

  process: ->
    throw "abstract"

module.exports = Base