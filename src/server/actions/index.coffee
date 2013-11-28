module.exports = class Index extends require('./base')
  handle: (cb) ->
    course = @course()
    @render("index",units: course.units)