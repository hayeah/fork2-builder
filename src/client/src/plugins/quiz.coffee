module.exports = (els,options={}) ->
  window.quizzes = for el in els
    new Quiz(el)

QuizGrader = require("../ui/quiz-grader")
QuizMany = require("../ui/quiz-many-jsx")
QuizInput = require("../ui/quiz-input-jsx")

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


