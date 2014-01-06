module.exports = (els) ->
  for el in els
    new Play(el)

class Play
  constructor: (el) ->
    @$ = $(el)
    @$button = $(".play-button",el)
    @$button.on "click", =>
      console.log "clicked", el

