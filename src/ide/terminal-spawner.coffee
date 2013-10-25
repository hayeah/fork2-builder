define (require) ->
  $ = require "jquery"
  Socket = require "socketio"
  Term = require "ide/terminal"

  class TermSpawner
    constructor: (@endpoint) ->
      @ttys = {}

      @so = Socket.connect(@endpoint)
      @onConnect = $.Deferred()
      @so.on "connect", =>
        @onConnect.resolve()
        console.log "TermSpawner connected"

      @so.on "data", (msg) =>
        console.log ["msg",msg]
        @proxyData(msg)

    proxyData: (msg) ->
      id = msg.id
      tty = @ttys[id]
      return unless tty
      tty.input(msg.data)

    spawn: (el,opts,cb) ->
      opts ||= {}
      @onConnect.done =>
        term = new Term(@so,el,opts.w,opts.h)
        @ttys[term.id] = term
        cb(term) if cb