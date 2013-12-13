view_id = "#page-view"

refHighlight = require("./ref-highlight")
quiz = require("./quiz")

$ ->
  require("./footnote-display")(view_id)
  require("./footnote-ref")(view_id)
  # refHighlight()
  quiz()