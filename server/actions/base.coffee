module.exports = class BaseAction
  constructor: (@req,@res,@express) ->
    @params = @req.params
    @root = @express.get("root")

  get: (key) ->
    @express.get(key)

  handle: ->
    throw "abstract"