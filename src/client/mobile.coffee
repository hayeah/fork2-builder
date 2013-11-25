define [
  "jquery"
  "fastclick"
  "bootstrap"
  ], ($,FastClick) ->
  $(".btn-group button").click (e) ->
    $(".which").text $(e.target).text()

  $ ->
    FastClick.attach(document.body)
