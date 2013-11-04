requirejs.config
  packages: [
    {
      name: "ace"
      location: "bower_components/ace/lib/ace"
      main: "ace"
    }
  ]
  paths:
    reveal: "bower_components/reveal.js/js/reveal"
    jquery: "bower_components/jquery/jquery"
    underscore: "bower_components/underscore/underscore"
    almond: "bower_components/almond/almond"
    "jquery.layout": "lib/jquery.layout-latest"
    "jquery.ui.core": "bower_components/jquery-ui/ui/jquery.ui.core"
    "jquery.ui.widget": "bower_components/jquery-ui/ui/jquery.ui.widget"
    "jquery.ui.mouse": "bower_components/jquery-ui/ui/jquery.ui.mouse"
    "jquery.ui.position": "bower_components/jquery-ui/ui/jquery.ui.position"
    "jquery.ui.draggable": "bower_components/jquery-ui/ui/jquery.ui.draggable"
    "termjs": "bower_components/term.js/src/term"
    "socketio": "bower_components/socket.io-client/dist/socket.io"

  shim:
    underscore:
      exports: "_"
    reveal:
      exports: "Reveal"
    termjs:
      exports: "Terminal"
    "jquery.layout": ["jquery.ui.draggable"]
    "jquery.ui.core": ["jquery"]
    "jquery.ui.widget": ["jquery.ui.core"]
    "jquery.ui.mouse": ["jquery.ui.widget"]
    "jquery.ui.draggable": ["jquery.ui.mouse"]

