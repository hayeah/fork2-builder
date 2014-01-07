class PingServer
  constructor: (@so) ->
    i = 0
    @timer = setInterval((=>
        i++
        @so.emit("ping",i)
      ),500
    )
    @so.on "pong", (i) ->
      console.log "pong", i

  close: ->
    clearInterval(@timer)

module.exports = PingServer