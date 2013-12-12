{div,ul,li} = React.DOM

Fib = React.createClass {
  getInitialState: ->
    {fibs: [1]}

  clicked: ->
    fibs = @state.fibs
    n = fibs.length
    if n == 0 or n == 1
      i = 1
    else
      i = fibs[n-1] + fibs[n-2]
    fibs.push(i)
    @setState fibs: fibs

  render: ->
    items = for n in @state.fibs
      li({},"fib(#{_i}): #{n}")
    div(
      {onClick: @clicked},
      @props.children,
      ul({className: "fibs"},items),
      div({},"clicked #{@state.fibs.length} times")
      )
  }

$ ->
  React.renderComponent \
    Fib(),
    $("#react-sandbox")[0]