define [
  "fastclick"
  "mobile/views/page"
  ], (FastClick) ->

  $ ->
    FastClick.attach(document.body)
