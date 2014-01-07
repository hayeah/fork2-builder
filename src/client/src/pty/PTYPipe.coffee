# Handles communication with remote pty.
#
# We'll assume that socket.io is reliable. So we are not going to worry about
# heartbeat, and that there won't be message losses. If the underlying socket
# disconnects, the server-side blows away all ptys, and the client side should
# respawn everything on reconnect.
#
# TODO: If the underlying connection goes away, we should respawn pipe on connect.
RxObject = require("../rx/RxObject")

class PTYPipe extends RxObject
  ###*
  @param {PTYServer.Program} program
  ###
  constructor: (@conn,@id,@program) ->
    @setRx {
      # is the pty program running?
      isRunning: false
    }
    # all messages passed into this channel
    @rawReader = conn.listen(@id) # .doAction ((data) -> console.log(data))

    # data messages to pipe into terminal
    @dataReader = @rawReader.filter (data) -> typeof data == "string"

    # terminal control messages
    @ctrlReader = @rawReader.filter (data) -> data instanceof Array

    @ctrlReader.onValue (data) => @handleCtrl(data)

  handleCtrl: (data) =>
    [type,rest...] = data
    switch type
      when "exit"
        @setRx isRunning: false

  # Spawns a remote terminal
  spawn: (size,cb) ->
    # use the current ui terminal size
    # @uiPTYSize.take(1).onValue (size) =>
    @conn.send "spawn", @id, size, @program, =>
      @setRx isRunning: true
      cb(size) if cb

  resize: (size,cb) ->
    @write ["resize",size], =>
      # downstream resize if remote call is success
      cb(size) if cb
      # @setRx PTYSize: size

  write: (args...) ->
    @conn.send(@id,args...)

  close: ->
    @conn.send(@id,["close"])

module.exports = PTYPipe