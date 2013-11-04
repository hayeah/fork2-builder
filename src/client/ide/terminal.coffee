define (require) ->
# define ["jquery","termjs"],($,Terminal) ->
  require "lib/source-code-pro"
  $ = require "jquery"
  Terminal = require "termjs"
  # Incrementing counter that gives each Term instance a unique id
  id = 0

  # This is the client-side terminal emulator. It mirrors a server-side
  # tty, doing IO via websocket.
  class Term
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
  