Course = require "../../models/course"
path = require 'path'

module.exports = class BaseAction
  constructor: (@req,@res,@app) ->
    @express = @app.express
    @root = @app.contentRoot
    @params = @req.params

  # Processes a HTTP request by delegating to the @handle method.
  process: ->
    console.log @req.route
    @handle (err,httpcode=500) =>
      if err
        @res.status(httpcode)
        if err instanceof Error
          message = err.message
        else
          message = err

        @res.end(message)

  # Action logic to override in subclass.
  handle: (cb) ->
    cb("abstract method")

  get: (key) ->
    @express.get(key)

  # we want to exclude tablets from mobile view
  mobileRE = /mobile/i
  isMobile: ->
    switch @req.query.display
      when "mobile"
        return true
      when "desktop"
        return false

    ua = @req.headers["user-agent"] || ""

    if mobileRE.exec(ua)
      true
    else
      false

  # Get the Course model for the current running project.
  # @return {Course}
  course: ->
    @_course ||= Course.load(path.join(@root,"course.json"))

  render: (view,locals={}) ->
    opts = Object.extended({})

    if @isMobile()
      opts.layout = "mobile"
      opts.isMobile = true

    opts = opts.merge(locals)

    @res.render(view,opts)

  handle: ->
    throw "abstract"
