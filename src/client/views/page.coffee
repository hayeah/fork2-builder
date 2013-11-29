view_id = "#page-view"

define [], () ->
  class PageView
    constructor: (el) ->
      @$ = $(el)
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
        console.log ["highlight",@currentContent]

  $ ->
    window.pv = new PageView(view_id)


