{div,span,button,table,tr,td,p} = React.DOM
cx = React.addons.classSet

QuizGrader = React.createClass {
  displayName: "QuizGrader"

  getInitialState: ->
    {
      # user answers
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

    for entry, i in entries
      results[i] = result = @isCorrect(i)

    @setState {
      isGraded: true
      results: results
    }

  # If the quiz is graded, is everything ok? Returns null if not graded.
  # @return {Boolean|Null}
  isSuccess: ->
    return if !@state.isGraded

    entries = @getEntries()

    success = true
    i = 0
    while i < entries.length
      success = false if not @state.results[i]
      i++

    return success

  getQuizEntry: (i) ->
    quizEntry = @refs["entry-#{i}"]

  isCorrect: (i) ->
    @getQuizEntry(i).isCorrect()

  setAnswer: (i,val) ->
    @state.answers[i] = val
    @setState {
      answers: @state.answers
    }

  renderEntry: (klass,entry,i) ->
    showError = @state.isGraded && @state.results[i] == false
    ref = "entry-#{i}"
    klass({
      ref: ref
      key: ref
      entry: entry, index: i
      showError: showError
      setAnswer: @setAnswer.bind(@,i)
      answer: @state.answers[i]
    })

  # @prop {ReactClass} type The React component class used to render each entry of a quiz.
  render: ->
    entries = @props.data
    rows = for entry, i in entries
      @renderEntry(@props.type,entry,i)

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

module.exports = QuizGrader