# Acts like a Bus that you can push to, but buffers values if it's not subscribed to.
class RxBuffer
  constructor: (@upstream) ->
    sink = undefined
    buffer = []
    unsubscribe = ->
      sink = undefined
    subscribe = (newSink) =>
      # this is invoked the first time a listener subscribes
      sink = newSink
      for val in buffer
        sink(val)

      buffer.length = 0
      # the returned unsubscribe function is invoked when the last listener unsubscribes
      return unsubscribe

    innerStream = Bacon.fromBinder subscribe

    @push = (val) ->
      if sink
        sink(val)
      else
        buffer.push val

    @toProperty = (args...) ->
      innerStream.toProperty(args...)

    @onValue = (f) ->
      innerStream.onValue(f)

module.exports = RxBuffer