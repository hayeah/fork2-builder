module.exports = class Index extends require('./base')
  handle: (cb) ->
    course = @currentCourse()
    @render("index",units: course.units)