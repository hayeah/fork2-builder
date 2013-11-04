Base = require './base'

module.exports = class Terminal extends Base
  handle: ->
    @res.render("terminal")
