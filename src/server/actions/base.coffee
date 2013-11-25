module.exports = class BaseAction
  constructor: (@req,@res,@app) ->
    @express = @app.express
    @root = @app.contentRoot
    @params = @req.params

  get: (key) ->
    @express.get(key)

  # we want to exclude tablets from mobile view
  mobileRE = /mobile/i
  isMobile: ->
    ua = @req.headers["user-agent"] || ""

    if mobileRE.exec(ua)
      true
    else
      false

  render: (view,locals={}) ->
    opts = Object.extended({})

    if @isMobile()
      opts.layout = "mobile"
      opts.isMobile = true

    opts = opts.merge(locals)

    @res.render(view,opts)

  handle: ->
    throw "abstract"
