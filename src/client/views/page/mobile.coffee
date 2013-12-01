# Add
id = "#page-view"
define [
  "views/page/codeblock"
  "views/page/ref-highlight"
  ], (codeblock,refHighlight) ->
  $ ->
    codeblock $(id).find("pre code")
    refHighlight()
