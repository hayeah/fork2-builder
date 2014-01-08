# A PTY session running on a pipe. It respawns itself on exit. It also
# synchronize a terminal with remote pty size.
#
# Propogation of pty size: ui ptysize -> pipe ptysize -> term ptysize
#
# + window resize causes component ptysize to change
# + component ptysize causes pipe ptysize to change, which causes remote ptysize to change
# + pipe ptysize change causes terminal emulator to resize

RESPAWN_LIMIT = 3


# @param {Bacon.Property.<PTYSize>} uiPTYSize

# @type {{rols: Integer, cols: Integer}} PTYSize The dimension of a pty

# @property {Bacon.Property.<PTYSize>} PTYSize The maximum allowable size for this pty. If it changes, should request remote pty to resize.
# @property {Bacon.Property.<PTYSize>} rx.remotePTYSize  When remote PTY successfully resizes, this value changes.
RxObject = require("RxObject")

class PTYSession extends RxObject
  # @param {PTYPipe} pipe
  # @param {Terminal} terminal Client side terminal object.
  constructor: (@pipe,@terminal,@PTYSize) ->
    @setRx {
      remotePTYSize: null
    }
    @spawn()

    @setupIO()
    @setupAutoRespawn()
    @setupAutoResize()

  setupIO: ->
    @pipe.dataReader.onValue (data) =>
      @terminal.write(data)

    @terminal.on "data", (data) =>
      @pipe.write(data)

  setupAutoRespawn: () ->
    # auto-respawn
    respawnEvents = @pipe.rx.isRunning.
      changes().
      skipDuplicates().
      filter((isRunning) -> isRunning == false)

    respawnEvents.take(RESPAWN_LIMIT).onValue =>
      @respawn()

    respawnEvents.skip(RESPAWN_LIMIT).take(1).onEnd =>
      @terminal.write("\r\nProgram restarted #{RESPAWN_LIMIT} times. Will not restart again.\r\n")


  # auto-resize with remote pty
  setupAutoResize: ->
    # Take the first value to resize local terminal.
    @PTYSize.take(1).onValue (size) =>
      # console.log "first set size", size
      @resizeLocal size

    # Synchronize local size with remotePTYSize
    @rx.remotePTYSize.changes().onValue (size) =>
      @resizeLocal size

    # Resize remote PTY as necessary.
    @PTYSize.changes().onValue @resizeRemote.bind(@)

  resizeLocal: (size) ->
    {cols,rows} = size
    @terminal.resize cols, rows

  resizeRemote: (size) ->
    @pipe.resize size, (remoteSize) =>
      @setRx remotePTYSize: remoteSize

  # TODO throttle spawn.
  spawn: ->
    @PTYSize.take(1).onValue (size) =>
      @pipe.spawn size, (remoteSize) =>
        @setRx remotePTYSize: remoteSize

  respawn: ->
    @terminal.write("\r\nProgram exited. Restarting\r\n")
    @spawn()


module.exports = PTYSession