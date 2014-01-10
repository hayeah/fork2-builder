{div,span,button} = React.DOM
cx = React.addons.classSet

Connection = require("Connection")
UITerminal = require("UITerminal")
RxReactMixin = require("RxReactMixin")

tUITerminal = React.createClass({
  mixins: [RxReactMixin]

  getInitialState: ->
    {
      term: null

      isConnected: false
    }

  getSize: ->
    $w = $(window)
    {width: $w.width() * 0.7 | 0,height: $w.height() * 0.5 | 0}

  # getDefaultProps: ->
  # componentWillMount: ->
  componentDidMount: (rootNode) ->
    @setRxState size: @getSize()

    resize = Bacon.fromEventTarget(window,"resize").throttle(300)
    resize.onValue =>
      @setRxState size: @getSize()

    @connect()
    @openTerm()

  connect: ->
    @conn = Connection.create()
    @conn.status.onValue (up) =>
      @setState isConnected: up

  openTerm: (command="bash") ->
    program = {
      command: command
      type: "repl"
    }
    term = UITerminal({
      key:"pty-1"
      conn: @conn
      size: @rx.size
      program: program
    })

    @setState term: term


  # componentWillReceiveProps: (nextProps) ->
  # shouldComponentUpdate: (nextProps,nextState) ->
  # componentWillUpdate: (nextProps,nextState) ->
  # componentDidUpdate: (prevProps,prevState,rootNode) ->
  # componentWillUnmount: ->

  render: ->
    {height,width} = @state.size || {}
    containerCSS = {
      height: height
      width: width
      border: "1px solid black"
      overflow: "hidden"
    }
    div({}
      "#{width}x#{height}, isConnected: #{@state.isConnected}, program: #{JSON.stringify @state.term?.props.program}"
      div({},
        button({className: "btn btn-primary",onClick: @openTerm.bind(@,"irb")},"IRB")
        button({className: "btn btn-primary"  ,onClick: @openTerm.bind(@,"python")},"Python",)
      )
      div({style: containerCSS},@state.term)
    )
})

module.exports = tUITerminal