define (require) ->
  require("jquery.layout")
  ace = require("ace")
  modelist = require 'ace/ext/modelist'
  Term = require("ide/term")

  template = """
  <div class="ide">
    <div class="ui-layout-center ide-workarea">
      <div class="ui-layout-center">
        <div class="ide-editor">
        </div>
        <div class="btn-group ide-control">
          <a class="btn btn-primary ide-run">Run</a>
        </div>
      </div>

      <div class="ui-layout-south">
        <div class="ide-terminal">
        </div>
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
      @$workarea = @$.find(".ide-workarea")
      @$editor = @$.find(".ide-editor")
      @$start_dialog = @$.find(".ide-start-dialog")
      @$start_button = @$.find(".ide-start-dialog .btn")
      @$tutorial_container = @$.find(".ide-tutorial-container")
      @$term = @$.find(".ide-terminal")
      @$run = @$.find(".ide-run")
      @$run.click =>
        @run()

      @$container.layout
        west:
          minSize: 300

      @$workarea.layout
        south:
          minSize: 250

      @ace = ace.edit(@$editor.get(0))
      @term = new Term(@$term)

    # displays element as tutorial instruction text
    setTutorialInstruction: (el) ->
      @$tutorial_container.html(el)

    # set the tutorial content
    setTutorial: (@tutorial) ->
      @tutorial.setIDE(this)
      @tutorial.goto_first()

    # dynamically dispatches an IDE action
    dispatch: (action) ->
      @runData = null
      method = this[action.type]
      method.call(@,action.data)

    # Enters into edit mode. It sets @getRunData to a function that
    # builds the json object that is sent to runner.
    edit: (opts) ->
      # TODO: I think this is something like an entry point to a mode.
      # And `run` should be a method of the mode.
      file = opts.file
      match = modelist.getModeForPath(file.path)
      mode = match.mode
      @ace.getSession().setValue file.content
      @ace.getSession().setMode mode

      @getRunData = => {
        type: "edit"
        data: {
          file: {
            content: @ace.getSession().getValue()
            path: file.path  
          }
          run: opts.run
        }
      }

    # TODO: should be a mode method... probably.
    # runs the current program
    run: ->
      data = @getRunData()
      console.log data


    start: ->
      @$start_dialog.hide()

    stop: ->
      @$start_dialog.show()
