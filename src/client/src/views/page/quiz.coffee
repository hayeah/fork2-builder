QuizChooseMany = require("./quiz-choose-many")
QuizInput = require("./quiz-input")
# QuizChooseMany = require("./quiz-choose-many")

controls = {
  "choose-many": QuizChooseMany
  "input": QuizInput
}

class Quiz
  constructor: (el) ->
    @$ = $(el)
    @type = @$.data("quiz-type")
    data = @$.data("quiz-data")

    controlType = controls[@type]
    return if !controlType
    @control = new controlType(el,data)


module.exports = plugin = ->
  window.quizzes = $("#page-view .quiz").map (i,el) ->
    new Quiz(el)

