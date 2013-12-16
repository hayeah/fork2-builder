fs = require 'fs'
Unit = require "./unit"

# @class {Course} Represents a course, as described by a project's course.json
class Course
  # @attr {[Unit]} units contained in the course.
  units: []

  # @param data.content {[Path]} sequence of content files for this course.
  constructor: (data) ->
    @metadata = data
    prev_unit = null

    @units = []
    for path in data.content
      unit = new Unit(this,path,prev_unit)
      @units.push unit
      prev_unit = unit

  # @return {Unit} the first unit of the course with that permalink
  findByPermalink: (permalink) ->
    for unit in @units
      return unit if unit.permalink == permalink

    return null


# Loads course from given path as json
# @return Course
Course.load = (path) ->
  json = fs.readFileSync(path,{encoding: "utf8"})
  data = JSON.parse(json)
  new Course(data)

module.exports = Course