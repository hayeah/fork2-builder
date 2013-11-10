module.exports = class BaseAction
  constructor: (@req,@res,@root,@express) ->
    @params = @req.params

  get: (key) ->
    @express.get(key)

  handle: ->
    throw "abstract"
