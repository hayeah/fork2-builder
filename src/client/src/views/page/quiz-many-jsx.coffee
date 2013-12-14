{div,span,button,table,tr,td,p} = React.DOM
cx = React.addons.classSet

QuizMany = React.createClass {
  displayName: "QuizMany"

  getInitialState: ->
    {
      # whether user selected a choice
      selected: []

      # whether we graded the quiz
      isGraded: false

      # store the graded results
      results: []
    }

  getEntries: ->
    @props.data

  grade: ->
    entries = @props.data

    results = []
    i = 0
    while i < entries.length
      results[i] = result = @isCorrect(i)
      i++

    @setState {
      isGraded: true
      results: results
    }

  reset: ->
    @setState @getInitialState()

  # is the answer for the ith entry correct?
  isCorrect: (i) ->
    entries = @getEntries()
    entry = entries[i]
    answer = !!entry.accept
    userAnswer = !!@state.selected[i]
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

  # toggle select ith entry
  toggleSelect: (i) ->
    @state.selected[i] = !@state.selected[i]
    @setState selected: @state.selected

  render: ->
    entries = @props.data
    rows = for entry, i in entries
      showError = @state.isGraded && @state.results[i] == false
      entrycx = cx {
        "quiz-entry": true
        "selected": !!@state.selected[i]
        "error": showError
      }
      warnIconcx = cx {
        "invisible": !showError
      }
      errorMsgcx = cx {
        "hidden": !showError || typeof entry.error != "string"
      }
      div({className: entrycx, key: "entry-#{i}",onClick: @toggleSelect.bind(@,i)}
        span({className: "quiz-icons"}
          div({className: "glyphicon glyphicon-warning-sign #{warnIconcx}"})
          div({className: "quiz-checkbox glyphicon glyphicon-ok"})
          )
        div({className: "quiz-entry-content"}
          div(dangerouslySetInnerHTML: {__html: entry.text})
          div({className: "alert alert-warning #{errorMsgcx}"},entry.error)
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

module.exports = QuizMany