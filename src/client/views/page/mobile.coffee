# Add
id = "#page-view"
codeblock = require("./codeblock")

$ ->
  codeblock $(id).find("pre code")

# define [
#   "views/page/codeblock"
#   "views/page/ref-highlight"
#   ], (codeblock,refHighlight) ->
#   $ ->
#     codeblock $(id).find("pre code")
#     refHighlight()
