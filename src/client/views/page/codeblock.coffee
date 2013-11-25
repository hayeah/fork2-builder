define ["jquery"], ($) ->
  toggleWrapButtonHTML = """
    <button type="button" class="code-toggle-wrap btn btn-default">
      <span class="glyphicon glyphicon-transfer"></span>
    </button>
    """

  class CodeBlock
    constructor: (el) ->
      @$ = $(el)

      # inject toggleWrap
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