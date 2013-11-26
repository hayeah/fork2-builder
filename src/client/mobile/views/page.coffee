# Add
id = "#page-view"
define ["mobile/codeblock"], (codeblock) ->
  $ ->
    codeblock $(id).find("pre code")
