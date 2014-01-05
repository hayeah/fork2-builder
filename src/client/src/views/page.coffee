view_id = "#page-view"

# refHighlight = require("./ref-highlight")
mods = [
  require("./page/quiz")
  require("./page/bigfoot")
]

$ ->
  require("./page/workspace")("#workspace","#main")
  for mod in mods
    mod(view_id)