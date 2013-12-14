{div,span,button,table,tr,td,p} = React.DOM
cx = React.addons.classSet

QuizChoice = React.createClass {
  displayName: "QuizChoice"
  # @props {Object} entry Data for the quiz question.
  # @props {Integer} index The index number of this entry in a quiz.
  # @props {Function(val)} setAnswer Pass user answer to parent.
  #
  # @props {Boolean} showError

  toggle: ->
    @props.setAnswer(!@props.answer)

  isCorrect: ->
    !!@props.entry.accept == !!@props.answer

  render: ->
    entry = @props.entry
    i = @props.index
    showError = @props.showError

    warnIconcx = cx {
      "invisible": !showError
    }
    errorMsgcx = cx {
      "hidden": !showError || typeof entry.error != "string"
    }
    div({className: "quiz-entry", onClick: @toggle}
      span({className: "quiz-icons"}
        div({className: "glyphicon glyphicon-warning-sign #{warnIconcx}"})
        div({className: "quiz-check glyphicon glyphicon-ok #{cx "selected": @props.answer}"})
        )
      div({className: "quiz-entry-content"}
        div(dangerouslySetInnerHTML: {__html: entry.text})
        div({className: "alert alert-warning #{errorMsgcx}"},entry.error)
        )
      )
}

module.exports = QuizChoice