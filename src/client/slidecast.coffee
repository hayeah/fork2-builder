define (require) ->
  hljs = require "highlightjs"
  Reveal = require "reveal"
  $ = require "jquery"
  IDE = require "ide"

  $ ->
    hljs.initHighlighting()

  class SlideCast
    constructor: ->
      Reveal.initialize
        center: true
        control: true
        transition: "linear"
        history: true

      @reveal = Reveal

      # @ide = new IDE("#ide")


