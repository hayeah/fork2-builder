module.exports = class Index extends require('./base')
  handle: (cb) ->
    course = @course()
    @render("index",course: course,units: course.units)