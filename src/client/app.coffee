# desktop app
define [
  "ide"
  "slidecast"
  "ace"
  "ace-modelist"
  ], ->
  # Configuration specific to bundled app

  # Configure ACE
  config = ace.require("ace/config")
  config.set("basePath","/bundle/ace")

  # do nothing. just declare dependencies