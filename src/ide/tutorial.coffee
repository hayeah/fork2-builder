define (require) ->
  jquery = require 'jquery'

  class Section
    constructor: (el) ->
      @$ = $(el)
      @$action = @$.find(".ide-action")

    ideAction: ->
      # FIXME For now, we assume there's one action.
      return null unless @$action.length > 0
      JSON.parse @$action.html()

  class Tutorial
    constructor: (el) ->
      @$ = $(el)
      @$sections = $.find("section")
      @sections = for e in @$sections
        new Section(e)

    setIDE: (@ide) ->

    goto_first: ->
      @goto(0)

    # Activate the nth section of this tutorial
    goto: (n) ->
      section = @sections[n]
      @ide.setTutorialInstruction(section.$)
      @ide.dispatch(section.ideAction())

  return Tutorial      
    
