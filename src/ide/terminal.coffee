define (require) ->
# define ["jquery","termjs"],($,Terminal) ->
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

      @tty.write "welcome to terminal\n"

    output: (data) ->
      @so.emit "data", {
        id: @id
        data: data
      }

    input: (data) ->
      @tty.write data

    exec: (data) ->
      w = @tty.cols
      h = @tty.rows

      # FIXME: Here we are assuming that websocket is already connected. Don't.
      @so.emit("exec",{
          id: @id,
          options: {w: w, h: h}
          data: data
      })

      @tty.on "data", (data) => 
        @output(data)
  