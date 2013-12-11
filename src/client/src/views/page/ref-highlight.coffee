#define [], () ->
class RefHighlight
  constructor: () ->
    # @$ = $(el)
    @highlightCurrentContent()

    $(window).on 'hashchange', =>
      console.log "hashchange"
      @highlightCurrentContent()

  highlightCurrentContent: ->
    @currentContent.removeClass("active") if @currentContent
    @currentContent = null
    if hash = window.location.hash
      @currentContent = $(hash)
      @currentContent.addClass("active")

plugin = ->
  new RefHighlight()

module.exports = plugin

# return plugin