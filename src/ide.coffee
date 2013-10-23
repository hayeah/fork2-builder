define (require) ->
  require("jquery.layout")
  ace = require("ace")

  template = """
  <div class="ide">
    <div class="ui-layout-center">
      <div class="ide-editor">
      </div>
    </div>
    <div class="ui-layout-west">Exercise Content</div>
  </div>
  """

  class IDE
    constructor: (el) ->
      @$ = $(el)
      @$.html(template)
      @$container = @$.find(".ide")
      @$editor = @$.find(".ide-editor")

      @$container.layout
        west:
          minSize: 300

      @ace = ace.edit(@$editor.get(0))