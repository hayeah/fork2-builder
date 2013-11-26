marked = require 'marked'
module.exports = class Code
  constructor: (@options) ->

  process: (cb) ->
    input = @options.fn(this)
    marked input, {}, cb