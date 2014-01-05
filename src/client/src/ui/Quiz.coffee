QuizGrader = require("./quiz-grader")
QuizMany = require("./quiz-many-jsx")
QuizInput = require("./quiz-input-jsx")

controls = {
  "choose-many": QuizMany
  "input": QuizInput
}

class Quiz
  constructor: (el) ->
    @$ = $(el)
    @type = @$.data("quiz-type")
    data = @$.data("quiz-data")

    @$wrapper = $("<div>")
    @$.append(@$wrapper)

    controlClass = controls[@type]
    return if !controlClass
    React.renderComponent(
      QuizGrader({type: controlClass, data: data})
      @$wrapper[0]
    )
    # @control = new controlType(el,data)


module.exports = plugin = ->
  window.quizzes = $("#page-view .quiz").map (i,el) ->
    new Quiz(el)

