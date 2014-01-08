module.exports = class Sample extends require('./base')
  handle: (cb) ->
    @res.render("uitests/#{@params.name}",name: @params.name)