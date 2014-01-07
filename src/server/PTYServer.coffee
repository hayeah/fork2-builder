PTY = require('pty.js')

# @typedef {{command: String}} PTYServer.Program
# @typedef {{cols: Integer, rows: Integer}} PTYServer.Size

class PTYInstance
  # @param {PTYServer.Size} size
  # @param {ShellProgram} program
  constructor: (@so,@id,@size,@program) ->
    check("ShellProgram",@program)
    @spawn()

  spawn: ->
    console.log "spawn", @size, @options
    command = @program.command || "bash"
    @pty = pty = PTY.spawn(command,[],{
      name: 'xterm-color'
      cols: @size.cols
      rows: @size.rows
      cwd: process.cwd()
      env: process.env
    })

    pty.on 'data', (data) =>
      @write(data)

    pty.on "exit", =>
      @ctrlWrite("exit")

    @so.on @id, (data,ack) =>
      if typeof data == "string"
        pty.write(data)
      else
        @handleCtrl(data,ack)

  handleCtrl: (data,ack) ->
    [type,args...] = data
    switch type
      when "resize"
        [size] = args
        @resize(size)
        ack(size)

  resize: (size) ->
    {cols,rows} = size
    @pty.resize cols, rows

  write: (data) ->
    @so.emit(@id, data)

  ctrlWrite: (args...) ->
    @so.emit(@id,args)

  close: ->

class PTYServer
  constructor: (@so) ->
    @ptys = {}
    @so.on "spawn", (id,size,program,ack) =>
      if oldPty = @ptys[id]
        console.log "close", id
        oldPty.close()
      console.log "spawn", id
      @ptys[id] = new PTYInstance(@so,id,size,program)
      ack(size)

module.exports = PTYServer