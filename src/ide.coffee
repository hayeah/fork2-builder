define (require) ->
  require("jquery-layout")
  $("body").layout()
  $("body > .ui-layout-center").layout()