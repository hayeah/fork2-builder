###* Interactive workspace for the {{play}} directive.
* @option {HideawayWorkspace} workspace (required) A workspace component to display {{play}} content.
###
module.exports = (els,options) ->
  window.plays = for el in els
    new Play(el,options)

class Play
  constructor: (el,@options) ->
    @$ = $(el)
    @$button = $(".play-button",el)
    playSpec = @$.data("play")
    workspace = @options.workspace
    @$button.on "click", =>
      workspace.open(playSpec)


