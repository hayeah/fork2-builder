Base = require './base'

module.exports = class Home extends Base
  handle: ->
    @res.end("Welcome")