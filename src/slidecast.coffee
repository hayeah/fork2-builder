define (require) ->
  Reveal = require "reveal"
  $ = require "jquery"

  class SlideCast
    constructor: ->
      Reveal.initialize
        center: true
        control: true
        transition: "linear"
        history: true

      @reveal = Reveal

    