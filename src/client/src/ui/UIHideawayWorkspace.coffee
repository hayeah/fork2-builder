check = require("check")
# This is an ugly abstraction. It probably should just provide Rx properties, other things coordinate with hideaway by reacting to it.
{div,span} = React.DOM
cx = React.addons.classSet

RxReactMixin = require("RxReactMixin")

UITerminal = require("UITerminal")
Connection = require("Connection")

###*
@attr {Connection} _conn A connection. Should call `this.ensureConnection` to initialize before use.
###

# @param {String} id
# @param {ShellProgram} spec
makePTY = (id,spec) ->
  UITerminal({key: id, program: spec})

HideawayWorkspace = React.createClass({
  mixins: [RxReactMixin]

  getInitialState: ->
    {
      content: null
    }

  getInitialRxState: ->
    {
      isActive: false

      # @type {DOMSize} amount of space available to display content, in pixels.
      contentSize: undefined
    }

  # getDefaultProps: ->
  # componentWillMount: ->

  componentDidMount: (rootNode) ->
    @rx.contentSize.log()

    $(window).on "keyup", (e) =>
      if e.keyCode == 191 # "/"
        @toggle()

  getContentSize: ->
    $contentEl = $ @refs.content.getDOMNode()
    {width: $contentEl.width(),height: $contentEl.height()}

  toggle: ->
    #console.log "before toggle", @getContentSize()
    @setRxState {isActive: !@state.isActive}, =>
      # console.log "after toggle", @getContentSize()
    # @setRxState isActive: !@state.isActive

  # Create a connection if workspace is not connected yet.
  ensureConnection: ->
    @_conn ||= Connection.create()

  # @param {PlaySpec} spec
  open: (spec) ->
    check "PlaySpec", spec
    @setRxState {isActive: true}, =>
      conn = @ensureConnection()
      shell = spec.open[0]
      content = UITerminal({
        key: "pty-1"
        program: shell
        size: @rx.contentSize
        conn: conn
        })

      @setRxState contentSize: @getContentSize()
      @setState content: content


  # componentWillReceiveProps: (nextProps) ->
  # shouldComponentUpdate: (nextProps,nextState) ->
  # componentWillUpdate: (nextProps,nextState) ->
  # componentDidUpdate: (prevProps,prevState,rootNode) ->
  # componentWillUnmount: ->

  render: ->
    cs = cx {
      hidden: !@state.isActive
    }

    div({className: "hideaway-workspace #{cs}"},
      div({ref: "content",className: "container"},@state.content)
    )
})

module.exports = HideawayWorkspace