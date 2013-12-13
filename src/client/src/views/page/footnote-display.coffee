{div,span,button} = React.DOM
cx = React.addons.classSet

FootnoteDisplay = React.createClass {
  getInitialState: ->
    {hidden: true, html: "", currentID: null}

  hide: ->
    @setState(hidden: true, html: "", currentID: null)

  show: (html="dummy content") ->
    @setState(hidden: false, html: html)

  toggle: (id) ->
    if !@state.currentID || @state.currentID != id
      @setState(currentID: id)
      @show($(id).html())
    else
      @hide()

  render: ->
    classes = cx({
      "hidden": @state.hidden == true
      "footnote-display": true
    })
    div {
        className: classes
      },
      div({className: "footnote-content", dangerouslySetInnerHTML: {__html: @state.html}}),
      button({
          type: "button"
          className: "close"
          onClick: @hide
        },"×")
}

# singleton FootnoteDisplay
display = null

plugin = (root) ->
  $ ->
    if el = $(".footnote-wrapper",root)[0]
      window.footnoteWrapper = display = React.renderComponent \
        FootnoteDisplay(),
        el

plugin.toggle = (id)->
  return if !display
  display.toggle(id)

module.exports = plugin