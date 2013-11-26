define ["jquery"], ($) ->
  toggleWrapButtonHTML = """
    <button type="button" class="code-toggle-wrap btn btn-default">
      <span class="glyphicon glyphicon-transfer"></span>
    </button>
    """

  class CodeBlock
    # applies to "pre code"
    constructor: (el) ->
      @$code = @$ = $(el)
      @setupToggleWrap()

    setupToggleWrap: ->
      # There is a span containing all the text content of the code block. Its
      # width, happily, is the maximum length of a line in the block.
      span = @$code.find("> span")
      # if the code container is large enough to contain the code snippet, we
      # don't show the wrap toggle.
      if @$code.width() > span.width()
        return

      # inject the toggle button
      @$toggleWrapButton = $(toggleWrapButtonHTML)
      @$.append(@$toggleWrapButton)
      @$toggleWrapButton.click =>
        @toggleWrap()

    toggleWrap: ->
      console.log "toggle linewrap"
      @$.toggleClass("linewrap")

  # jquery-esque plugin, without polluting the $.fn namespace.
  plugin = (el) ->
    $(el).each (i,e) ->
      $(e).data("codeblock",new CodeBlock(e))