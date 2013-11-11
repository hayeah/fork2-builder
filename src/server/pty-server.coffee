pty = require("pty.js")
path = require 'path'
fs = require 'fs'

# Multiplexes PTYs over a single socket.io connection.
# When a connection is broken, kill all PTYs.
module.exports = class PTYServer
  # @param so (Socket) websocket of connected client
  # @param root (Path) the project workspace this server is running as.
  constructor: (@so,@root) ->
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
  # @param msg (JSON) PTYClient request to exec something.
  # @param msg.id (Integer) the id for a PTYServerInstance
  #
  # The received msg is something like:
  # msg: { id: 1, options: { w: 80, h: 24 }, data: { run: '/bin/bash' } }
  exec: (msg) ->
    id = msg.id

    # if there's a previously running tty, close that first.
    if oldtty = @ttys[id]
      oldtty.kill()

    tty = new PTYServerInstance(@so,@root,id,msg)
    @ttys[id] = tty

# TODO: should handle "exit" event
class PTYServerInstance
  # @param so (Socket) see PTYServer
  # @param root (Path) see PTYServer
  # @param msg (JSON)  see PTYServer#exec
  # @param msg.data (Object) Data to pass into exec call
  # @param data.run (String) Command to run
  # @param data.file (Hash)  Overwrite the file at file.path with file.content before exec.
  # @param data.args ([Object]) (Optional) Arguments for the command to run
  constructor: (@so,@root,@id,msg) ->
    console.log ["TTY",msg]
    {data,options} = msg

    cmd = data.run
    args = data.args || []

    cwd = @root
    console.log ["exec cwd:",cwd]

    # FIXME: just use sync version of write for now
    if file = data.file
      fs.writeFileSync(path.join(cwd,file.path),file.content)

    @tty = pty.spawn "/bin/sh", ["-c",cmd],
      name: "xterm-color"
      cols: options.w
      rows: options.h
      cwd: cwd
      env: process.env

    @tty.on "data", (data) =>
      @output(data)

    @tty.on "exit", =>
      @tty = null

  output: (data) ->
    @so.emit "data", {
      id: @id
      data: data
    }

  input: (data) ->
    @tty.write(data) if @tty

  # kill the tty and its process
  kill: ->
    @tty.destroy() if @tty
