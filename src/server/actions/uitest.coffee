path = require "path"
module.exports = class Sample extends require('./base')
  handle: (cb) ->
    name = @params.name
    @render("uitest",name: name,uitest: true)