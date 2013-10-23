define (require) ->
  require("jquery.layout")
  ace = require("ace")

  template = """
  <div class="ide">
    <div class="ui-layout-center">
      <div class="ide-editor">
      </div>
      <div class="ide-start-dialog">
        <div class="ide-start-dialog-content">
          <a class="btn btn-primary btn-lg">Start Exercises</a>
          <p> or <a class="ide-skip-btn">skip </a> </p>
        </div>
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
      @$start_dialog = @$.find(".ide-start-dialog")
      @$start_button = @$.find(".ide-start-dialog .btn")

      @$container.layout
        west:
          minSize: 300

      @ace = ace.edit(@$editor.get(0))

    start: ->
      @$start_dialog.hide()

    stop: ->
      @$start_dialog.show()
