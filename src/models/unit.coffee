path = require 'path'
_s = require "underscore.string"
# @class {Unit} Represents a single content page in a course.
class Unit
  # @attr {Unit} previous unit of a course
  previous: null

  # @attr {Unit} next unit of a course
  next: null

  # @attr permalink {String}
  permalink: null

  # @attr {String} the type of content this is. Defaults to "page".
  type: null

  title: null

  # Path of the content file
  path: null

  # @param course {Course} The course that includes this unit
  # @param path {Path} The file to read the content for this unit.
  # @param previous {Unit} The unit that comes before this course within the course.
  # @param headers {[Header]} The headers extracted from content (only for compiled content).
  constructor: (course,@path,@previous,@headers) ->
    if @previous
      @previous.next = this

    @_parse_path()
    # @title = _s.titleize _s.humanize(@permalink)
    if @headers
      @title = @headers[0].text

  # Parses the content file path. Its format is `<permalink>[.<type>].hbs`
  _parse_path: ->
    re = /([^.]+)(\.[^.]+)?\.hbs$/
    filename = path.basename(@path)
    m = filename.match(re)

    if m
      @permalink = m[1]
      @type = m[2] || Unit.default_type

    return


Unit.default_type = "page"

module.exports = Unit