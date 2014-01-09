{div,span} = React.DOM
cx = React.addons.classSet

check = require('check')

PTYPipe = require("PTYPipe")
PTYSession = require("PTYSession")

###*
@property {Connection} conn A websocket connection
@property {Bacon.Property.<{width: Integer, height: Integer}>} size The width and height in pixels available for terminal
@property {String} key Unique id for this terminal
@property {ShellProgram} program Specify the repl to spawn
###

UITerminal = React.createClass({
  getInitialState: ->
    return {
      session: null

      # @type {Terminal} Terminal emulator
      term: null

      # @type {Bacon.Property.<{cols: Integer, rows:Integer}>} Current PTY dimensions
      ptySize: null

      #
      focus: false
    }

  # getDefaultProps: ->
  # componentWillMount: ->

  componentDidMount: (rootNode) ->
    check("ShellProgram",@props.program)
    term = @openPTY()
    ptySize = @setPTYSize(term)
    session = @connectPTY(term,ptySize)

  # Spawns a session using the current pty size
  # @return {null}
  connectPTY: (term,ptySize) ->
    ptySize.onValue (size) ->
      console.log "ptysize", size

    pipe = new PTYPipe(@props.conn,@props.key,@props.program)
    ptySession = new PTYSession(pipe,term,ptySize)
    @setState session: ptySession
    return ptySession

  # Renders the terminal into DOM.
  openPTY: ->
    el = @refs.pty.getDOMNode()
    term = new Terminal({
      useStyle: true
      # cols: @state.cols
      # rows: @state.rows
      cursorBlink: false
    })
    term.open(el)
    @setState term: term
    return term

  setPTYSize: ->
    el = @refs.pty.getDOMNode()
    cursor = $(el).find(".terminal-cursor")
    # cursorSize = [cursor.width(),cursor.height()] # this borks if terminal is not hidden. would be [0,0]
    cursorSize = [7,15] # FIXME: hardwire for now...

    calculatePTYSize = (contentSize) ->
      # -10 to account for 5px border all around
      w = contentSize.width - 10
      h = contentSize.height - 10
      {
        cols: Math.floor(w / cursorSize[0])
        rows: Math.floor(h / cursorSize[1])
      }

    ptySize = @props.size.map(calculatePTYSize).skipDuplicates((a,b) => a.cols == b.cols && a.rows == b.rows)
    @setState ptySize: ptySize
    return ptySize

  # componentWillReceiveProps: (nextProps) ->
  # shouldComponentUpdate: (nextProps,nextState) ->
  # componentWillUpdate: (nextProps,nextState) ->

  componentDidUpdate: (prevProps,prevState,rootNode) ->
    # focus and blurring when changing tabs
    if prevProps.focus == false && @props.focus == true
      @state.term.focus()

    if prevProps.focus == true && @props.focus == false
      @state.term.blur()

  componentWillUnmount: ->
    t = @state.term
    t.destroy()

  render: ->
    div({ref: "pty"})
})
module.exports = UITerminal