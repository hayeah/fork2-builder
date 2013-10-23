define (require) ->
  require("jquery.layout")
  $("body").layout
    west:
      minSize: 300
  $("body > .ui-layout-center").layout()