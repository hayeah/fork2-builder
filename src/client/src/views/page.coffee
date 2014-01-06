view_id = "#page-view"

play = require("../plugins/play")
quiz = require("../plugins/quiz")

mods = [
  require("./page/bigfoot")
]

HideawayWorkspace = require("../ui/HideawayWorkspace")

class Layout
  constructor: (workspace,main) ->
    @$main = $(main)
    @workspace = React.renderComponent HideawayWorkspace({}), $(workspace)[0]
    @$workspace = $(@workspace.getDOMNode())
    HEADER_HEIGHT = parseInt @$main.css("padding-top")

    # Synchronize content area's display with the hideaway workspace.
    @workspace.rx.isActive.onValue (isActive) =>
      if isActive
        @$main.css("padding-top": @$workspace.height() + HEADER_HEIGHT)
      else
        @$main.css("padding-top": HEADER_HEIGHT)

$ ->
  play $(".play")
  quiz $(".quiz")
  window.layout = new Layout("#workspace","#main")
  for mod in mods
    mod(view_id)