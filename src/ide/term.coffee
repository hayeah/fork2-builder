define (require) ->
  Terminal = require 'termjs'
  class Term
    constructor: (el,w,h) ->
      @$ = $(el)
      @tty = new Terminal
        cols: w
        rows: h
        screenKeys: true
        cursorBlink: false

      @tty.open @$.get(0)

      @tty.write "welcome to terminal\n"



  return Term
    
  