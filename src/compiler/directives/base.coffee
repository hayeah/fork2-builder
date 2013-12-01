marked = require 'marked'

class Base
  # @param options {Hash} The options object given to a mustache helper.
  # @param options.root {Path} The project root.
  # @param options.hbs {Path} The Handlebars instance used to render this template.
  constructor: (@options) ->
    @hbs = @options.hbs
    @root = @options.root
    # Is this directive being invoked as a block helper?
    @isBlock = !!@options.fn
    @hash = @options.hash

  # Return the block content as raw string. If given an object, use that
  # object as the context for the block content.
  #
  # @return {String}
  contentString: (context={}) ->
    if fn = @options.fn
      fn(context || this)

  # Recursively render the block content as template.
  # @return {HTMLString}
  content: (context={}) ->
    content = @contentString()
    template = @hbs.compile(content)
    hbsOutput = template(context)
    marked(hbsOutput,{})

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

  process: ->
    throw "abstract"

module.exports = Base