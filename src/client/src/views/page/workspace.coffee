headerHeight = 50
headerMargin = 20

class Workspace
  constructor: (@$workspace,@$main) ->
    @isHidden = true
    @setPctHeight(1/3)

    $(window).resize _.debounce ((e) =>
      @adjustContainerHeights()
    ), 300

  # showMore: ->
  #   @show(2/3)

  # showLess: ->
  #   @show(1/3)

  minimize: ->
    @setHeight(100)

  maximize: ->
    @setMainHeight(200)

  # showMin: ->
  #   @show(150)

  show: () ->
    return if !@isHidden
    @isHidden = false
    @$workspace.css(top: -@currentHeight).show()
    @$workspace.animate(top: headerHeight)
    @$main.animate("padding-top": @mainTop)

  setPctHeight: (pctHeight) ->
    @setHeight $(window).height() * pctHeight

  setHeight: (height) ->
    @currentHeight = height
    @adjustContainerHeights()

  # main height = window - headertotal - workspace
  setMainHeight: (mainHeight) ->
    workSpaceHeight = $(window).height() - headerHeight -  headerMargin - mainHeight
    @setHeight workSpaceHeight

  adjustContainerHeights: () ->
    @mainTop = @currentHeight + headerHeight + headerMargin

    if !@isHidden
      @$workspace.animate height: @currentHeight
      @$main.animate "padding-top": @mainTop
    else
      @$workspace.height @currentHeight

  hide: ->
    return if @isHidden
    @isHidden = true
    @$workspace.animate(top: -@$workspace.height())
    @$main.animate("padding-top": headerHeight+headerMargin)


plugin = (workspace,main) ->
  window.workspace = new Workspace($(workspace),$(main))

module.exports = plugin