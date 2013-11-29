class Base
  # @param options {Hash} The options object given to a mustache helper.
  # @param options.root {Path} The project root.
  constructor: (@options) ->
    @root = @options.root
    # Is this directive being invoked as a block helper?
    @isBlock = !!@options.fn

  # Return the block content as raw string. If given an object, use that
  # object as the context for the block content.
  #
  # @return {String}
  contentString: (context=null) ->
    if fn = @options.fn
      fn(context || this)

  process: ->
    throw "abstract"

module.exports = Base