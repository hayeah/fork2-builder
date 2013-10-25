pty = require("pty.js")

class TTY
  constructor: (@so,@id,options,data) ->
    cmd = data.run

    @tty = pty.spawn cmd, [],
      name: "xterm-color"
      cols: options.w
      rows: options.h
      cwd: process.env.HOME
      env: process.env

    @tty.on "data", (data) =>
      @output(data)

  output: (data) ->
    @so.emit "data", {
      id: @id
      data: data
    }

  input: (data) ->
    @tty.write(data)


# Multiplexes PTYs over a single socket.io connection.
# When a connection is broken, kill all PTYs.
module.exports = class PTYServer
  # @param socket (Socket) websocket of connected client
  constructor: (@so) ->
    # track spawned ttys
    @ttys = {}

    @so.on "data", (msg) =>
      @proxyInput(msg)

    @so.on "exec", (msg) =>
      @exec msg

  # @params msg.id (Integer) the tty id to write to
  # @params msg.data (Bytes) on the wire data chunk to write to tty
  proxyInput: (msg) ->
    id = msg.id
    tty = @ttys[id]
    return unless tty
    tty.input(msg.data)

  # spawns a tty, using data as runner spec.
  # @param ptyID (Integer) 
  #
  # The received msg is something like:
  # msg: { id: 1, options: { w: 80, h: 24 }, data: { run: '/bin/bash' } }
  exec: (msg) ->
    ttyID = msg.id    
    tty = new TTY(@so,ttyID,msg.options,msg.data)
    @ttys[ttyID] = tty