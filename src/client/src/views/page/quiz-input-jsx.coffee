{div,br,span,button,p,input} = React.DOM
cx = React.addons.classSet

QuizInput = React.createClass {
  displayName: "QuizInput"

  getInitialState: ->
    {
      # strings that user inputed as answers
      answers: []

      # whether we graded the quiz
      isGraded: false

      # store the graded results
      results: []
    }

  reset: ->
    @setState @getInitialState()

  getEntries: ->
    @props.data

  grade: ->
    entries = @getEntries()

    results = []
    i = 0
    while i < entries.length
      results[i] = result = @isCorrect(i)
      i++

    @setState {
      isGraded: true
      results: results
    }

  # is the answer for the ith entry correct?
  isCorrect: (i) ->
    entries = @getEntries()
    entry = entries[i]
    answer = entry.accept
    $input = $(this.refs["input-#{i}"].getDOMNode())
    userAnswer = $input.val()
    answer == userAnswer

  # If the quiz is graded, is everything ok? Returns null if not graded.
  # @return {Boolean|Null}
  isSuccess: ->
    return if !@state.isGraded

    entries = @props.data

    success = true
    i = 0
    while i < entries.length
      success = false if not @state.results[i]
      i++

    return success

  onInput: (i,e) ->
    answers = @state.answers
    answers[i] = e.target.value
    @setState {
      answers: answers
    }

  render: ->
    entries = @getEntries()
    rows = for entry, i in entries
      showError = @state.isGraded && @state.results[i] == false
      warnIconcx = cx {
        "invisible": !showError
      }
      errorMsgcx = cx {
        "hidden": !showError
      }
      div({className: "quiz-entry", key: "entry-#{i}"}
        span({className: "quiz-icons"}
          div({className: "glyphicon glyphicon-warning-sign #{warnIconcx}"})
          div({className: "quiz-checkbox glyphicon glyphicon-edit"})
        )
        div({className: "quiz-entry-content"}
          div(dangerouslySetInnerHTML: {__html: entry.text})
          input({
            className: "quiz-input form-control", ref: "input-#{i}",
            type: "text", value: @state.answers[i] || "",
            onChange: @onInput.bind(@,i)
            })
          p({className: "alert alert-warning #{errorMsgcx}"},entry.accept)
        )
      )

    success = @isSuccess() # note: if quiz is not graded, success is "null"

    quizResultcx = cx {
      "hidden": !@state.isGraded
      "alert-success": success == true
      "alert-danger": success == false
    }

    if success == true
      quizResultText = "Good job!"
    else if success == false
      quizResultText = "Sorry, wrong answer."

    div({}
      rows
      button({onClick: @grade, className: "btn btn-primary"},"Verify")
      " "
      button({onClick: @reset, className: "btn btn-default #{cx 'hidden': !@state.isGraded}"},"Try Again")
      p({})
      div({className:"quiz-result alert #{quizResultcx}"},quizResultText)
    )
}

module.exports = QuizInput