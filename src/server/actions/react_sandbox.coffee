Base = require './base'

module.exports = class ReactSandbox extends Base
  handle: ->
    @res.render('react')
