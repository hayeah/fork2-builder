{div,br,span,button,p,input} = React.DOM
cx = React.addons.classSet

QuizInput = React.createClass {
  displayName: "QuizInput"

  isCorrect: ->
    answer = @props.entry.accept
    answer == @props.answer

  # Get user answer for the ith entry.
  # @param {Synthetic} e The event dispatched
  onInput: (e) ->
    answer = e.target.value
    @props.setAnswer answer

  render: ->
    entry = @props.entry
    i = @props.index
    showError = @props.showError

    warnIconcx = cx {
      "invisible": !showError
    }
    errorMsgcx = cx {
      "hidden": !showError
    }
    div({className: "quiz-entry"}
      span({className: "quiz-icons"}
        div({className: "glyphicon glyphicon-warning-sign #{warnIconcx}"})
        div({className: "glyphicon glyphicon-edit"})
      )
      div({className: "quiz-entry-content"}
        div(dangerouslySetInnerHTML: {__html: entry.text})
        input({
          className: "quiz-input form-control", ref: "input-#{i}",
          type: "text", value: @props.answer || "",
          onChange: @onInput
          })
        p({className: "alert alert-warning #{errorMsgcx}"},entry.accept)
      )
    )

}

module.exports = QuizInput