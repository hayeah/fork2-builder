glob = require 'glob'
path = require 'path'
Course = require "../../models/course"

module.exports = class Index extends require('./base')
  handle: (cb) ->
    course = Course.load(path.join(@root,"course.json"))
    console.log course

    @render("index",units: course.units)