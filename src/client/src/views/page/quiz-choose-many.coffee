shuffle = (arr) ->
  i = arr.length;
  if i == 0
    return []

  while --i
    j = Math.floor(Math.random() * (i+1))
    tempi = arr[i]
    tempj = arr[j]
    arr[i] = tempj
    arr[j] = tempi
  return arr

template = require("./quiz-choose-many.hbs")

class Choice
  constructor: (el,@answer) ->
    @$ = $(el)
    @$checkbox = @$.find(":checkbox")
    @$errorMessage = @$.find(".error-message")

  verify: ->
    ok = @$checkbox.is(":checked") == !!@answer.accept
    if ok
      @$.removeClass("error")
      @$errorMessage.addClass("hidden")

    else
      @$.addClass("error")
      if msg = @answer.error
        @$errorMessage.html(msg)
        @$errorMessage.removeClass("hidden")


    return ok

class QuizChooseMany
  constructor: (el,@data) ->
    @$ = $(el)

    @$view = @render()
    @$.append(@$view)
    @checkboxes = @$view.find(".entry").map (i,el) =>
      answer = @data[i]
      new Choice(el,answer)

    @$result = @$view.find(".quiz-result")

    @$done = @$view.find("button").click =>
      @verify()

  render: ->
    $(template(entries: @data))

  verify: ->
    ok = true
    for checkbox in @checkboxes
      if !checkbox.verify()
        ok = false

    if ok
      @$result.html("good!")
      @$result.removeClass("error")
    else
      @$result.html("bummer :(")
      @$result.addClass("error")

    return ok

module.exports = QuizChooseMany