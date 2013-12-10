# Add
id = "#page-view"
codeblock = require("./codeblock")
refHighlight = require("./ref-highlight")

$ ->
  codeblock $(id).find("pre code")
  refHighlight()
