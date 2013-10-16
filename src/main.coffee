requirejs.config
  paths:
    jquery: "bower_components/jquery/jquery"
    underscore: "bower_components/underscore/underscore"
    almond: "bower_components/almond/almond"
  shim:
    underscore:
      exports: "_"

define ["underscore"], ->
  console.log("define main")
  {foo: true,"u":_}

