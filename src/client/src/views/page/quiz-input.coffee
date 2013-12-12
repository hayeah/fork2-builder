template = require("./quiz-input.hbs")

class Entry
  constructor: (el,@answer) ->
    @accepts = @answer.accept
    if !Array.isArray(@accepts)
      @accepts = [@accepts]

    @$ = $(el)
    @$input = @$.find("input")
    @$result = @$.find(".quiz-result")
    @$check = @$.find("button.checkAnswer").click =>
      @verify()

    @$showAnswer = @$.find("button.showAnswer").click =>
      @showAnswer()

  showAnswer: ->
    @$result.html("Expects: #{@accepts[0]}")

  verify: ->
    ok = false
    for accept in @accepts
      if accept == @$input.val()
        ok = true

    if ok
      @$result.html("good!")
      @$result.removeClass("error")
      @$showAnswer.addClass("hidden")
    else
      @$result.html("bummer!")
      @$result.addClass("error")
      @$showAnswer.removeClass("hidden")

    ok

class QuizInput
  constructor: (el,@data) ->
    @$ = $(el)
    @$view = $("<div>")
    @$.append(@$view)

    @render()

  render: ->
    @$view.html template(entries: @data)
    @entries = @$view.find(".quiz-input-entry").map (i,el) =>
      new Entry(el,@data[i])

module.exports = QuizInput

