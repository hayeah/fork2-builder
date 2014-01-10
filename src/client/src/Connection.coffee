Socket = io
class Connection
  # @param {SocketIO} so A Socket.io socket.
  constructor: (@so) ->
    @bus = new Bacon.Bus()
    @buffer = []
    @isConnected = false

    @bus.onValue (args) =>
      @sendRemote args

    # @inputStream = buffer(@bus) # waitable and resumable bus
    connectEvents = Bacon.fromEventTarget(@so,"connect").map(true)
    disconnectEvents = Bacon.fromEventTarget(@so,"disconnect").map(false)
    @status = connectEvents.merge(disconnectEvents).toProperty().startWith(false)

    @status.changes().onValue (up) =>
      @isConnected = up
      @drainBuffer() if @isConnected

  # Returns a bacon event stream
  listen: (event) ->
    Bacon.fromEventTarget(@so,event)

  send: (args...) ->
    @bus.push args

  drainBuffer: ->
    # drain buffer first
    if @buffer.length > 0
      for bufferedArgs in @buffer
        @so.emit bufferedArgs...
      @buffer.length = 0

  sendRemote: (args) ->
    if !@isConnected
      @buffer.push args
      return

    @drainBuffer()

    @so.emit args...

create = ->
  so = Socket.connect()
  new Connection(so)

Connection.create = create

module.exports = Connection