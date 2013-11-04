Base = require './base'

module.exports = class ShowBootstrapDemo extends Base
  handle: ->
    @res.render('bootstrap')