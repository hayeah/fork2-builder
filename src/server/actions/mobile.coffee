Base = require './base'

module.exports = class Mobile extends Base
  handle: ->
    @res.render("mobile",layout: "mobile")
