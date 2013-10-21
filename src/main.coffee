requirejs.config
  paths:
    reveal: "bower_components/reveal.js/js/reveal"
    jquery: "bower_components/jquery/jquery"
    underscore: "bower_components/underscore/underscore"
    almond: "bower_components/almond/almond"
  shim:
    underscore:
      exports: "_"
    reveal:
      exports: "Reveal"

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

