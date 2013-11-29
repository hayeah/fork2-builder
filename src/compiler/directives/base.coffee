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

  process: ->
    throw "abstract"

module.exports = Base