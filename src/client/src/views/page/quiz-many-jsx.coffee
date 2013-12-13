{div,span,button,table,tr,td,p} = React.DOM
cx = React.addons.classSet

QuizMany = React.createClass {
  render: ->
    data = @props.data
    rows = for entry in data
      div({className: "quiz-entry"},
        span({className: "quiz-icons"},
          div({className: "glyphicon glyphicon-warning-sign"}),
          div({className: "quiz-checkbox glyphicon glyphicon-ok"})
          ),
        div({className: "quiz-entry-content"},
          div(dangerouslySetInnerHTML: {__html: entry.text}),
          div({className: "alert alert-danger"},"error text"))
        )
    div({},
      rows,
      button({className: "btn btn-primary"},"Verify"),
      p(),
      div({className:"quiz-result alert alert-success"},"good job!"),
      )

}

module.exports = QuizMany