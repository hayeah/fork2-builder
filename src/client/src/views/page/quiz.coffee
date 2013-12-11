QuizChooseMany = require("./quiz-choose-many")

class Quiz
  constructor: (el) ->
    @$ = $(el)
    @type = @$.data("quiz-type")
    data = @$.data("quiz-data")

    @control = new QuizChooseMany(el,data)


module.exports = plugin = ->
  window.quizzes = $("#page-view .quiz").map (i,el) ->
    new Quiz(el)

