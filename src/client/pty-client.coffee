# Incrementing counter that gives each PTYClientInstance instance a unique id
id = 0

# Multiplexes PTYs over a single socket.io connection.
# This is the client-side terminal emulator. It mirrors a server-side tty, doing IO via websocket.
define (require) ->
  $ = require "jquery"
  Socket = require "socketio"

  class PTYClient
    constructor: (@endpoint) ->
      @ttys = {}

      @so = Socket.connect(@endpoint)
      @onConnect = $.Deferred()
      @so.on "connect", =>
        @onConnect.resolve()
        console.log "PTY Socket Connected"

      @so.on "data", (msg) =>
        @proxyData(msg)

    proxyData: (msg) ->
      id = msg.id
      tty = @ttys[id]
      return unless tty
      tty.input(msg.data)

    spawn: (el,opts,cb) ->
      opts ||= {}
      @onConnect.done =>
        term = new PTYClientInstance(@so,el,opts.w,opts.h)
        @ttys[term.id] = term
        cb(term) if cb

  require "lib/source-code-pro"
  Terminal = require "termjs"
  
  class PTYClientInstance
    constructor: (@so,el,w,h) ->
      id += 1
      @id = id
      @$ = $(el)
      @tty = new Terminal
        cols: w
        rows: h
        screenKeys: true
        cursorBlink: false

      @tty.open @$.get(0)

      # FIXME: what happens if we try to send data before exec?
      @tty.on "data", (data) => 
        @output(data)

    output: (data) ->
      @so.emit "data", {
        id: @id
        data: data
      }

    input: (data) ->
      @tty.write data

    # @param data (Object) Data to pass into exec call
    # @param data.run (String) Command to run
    # @param data.args ([Object]) (Optional) Arguments for the command to run
    exec: (data) ->
      w = @tty.cols
      h = @tty.rows

      @so.emit("exec",{
          id: @id,
          options: {w: w, h: h}
          data: data
      })

  return PTYClient