fs = require "fs"
path = require "path"

Base = require './base'

module.exports = class ShowIDE extends Base
  handle: ->
    exercises = path.join(@root,"ex.html")
    fs.readFile exercises, {encoding: "utf8"}, (err,content) =>
      @res.render('ide',exercises: content,name: @params.name)
