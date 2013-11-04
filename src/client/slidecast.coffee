define (require) ->
  Reveal = require "reveal"
  $ = require "jquery"
  IDE = require "ide"

  class SlideCast
    constructor: ->
      Reveal.initialize
        center: true
        control: true
        transition: "linear"
        history: true

      @reveal = Reveal

      # @ide = new IDE("#ide")

    