view_id = "#page-view"

Socket = io
Connection = require("Connection")

play = require("../plugins/play")
quiz = require("../plugins/quiz")

mods = [
  require("./page/bigfoot")
]

HideawayWorkspace = require("UIHideawayWorkspace")

class PageLayout
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
  layout = new PageLayout("#workspace","#main")
  window.ws = layout.workspace
  play $(".play"), workspace: layout.workspace
  quiz $(".quiz")

  for mod in mods
    mod(view_id)