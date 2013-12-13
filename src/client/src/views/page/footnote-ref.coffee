
footnoteDisplay = require("./footnote-display")

plugin = (root) ->
  $(".ref",root).click (e) ->
    ref = $(e.target).attr("href")
    footnoteDisplay.toggle ref
    e.preventDefault()

module.exports = plugin