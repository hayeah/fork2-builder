define (require) ->
  require("jquery.layout")
  ace = require("ace")
  modelist = require 'ace/ext/modelist'

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
    <div class="ui-layout-west">
      <div class="ide-tutorial-container">
      </div>
    </div>
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
      @$tutorial_container = @$.find(".ide-tutorial-container")

      @$container.layout
        west:
          minSize: 300

      @ace = ace.edit(@$editor.get(0))

    # displays element as tutorial instruction text
    setTutorialInstruction: (el) ->
      @$tutorial_container.html(el)

    # set the tutorial content
    setTutorial: (@tutorial) ->
      @tutorial.setIDE(this)
      @tutorial.goto_first()

    # dynamically dispatches an IDE action
    dispatch: (action) ->
      method = this[action.type]
      method.call(@,action.data)

    edit: (opts) ->
      file = opts.file
      match = modelist.getModeForPath(file.path)
      mode = match.mode
      @ace.getSession().setValue file.content
      @ace.getSession().setMode mode


    start: ->
      @$start_dialog.hide()

    stop: ->
      @$start_dialog.show()
