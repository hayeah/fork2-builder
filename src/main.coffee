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

require(["app"])

