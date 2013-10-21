define (require) ->
  _ = require "underscore"
  Reveal = require "reveal"
  $ = require "jquery"
  Reveal.initialize
    center: true
    control: true
    transition: "linear"
    history: true
  console.log("define main")

  {foo: true,"u":_}