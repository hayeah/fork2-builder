view_id = "#page-view"

# refHighlight = require("./ref-highlight")
mods = [
  require("./quiz")
  require("./bigfoot")
]

$ ->
  for mod in mods
    mod(view_id)