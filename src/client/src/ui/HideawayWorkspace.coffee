check = require("check")
# This is an ugly abstraction. It probably should just provide Rx properties, other things coordinate with hideaway by reacting to it.
{div,span} = React.DOM
cx = React.addons.classSet

RxReactMixin = require("../rx/RxReactMixin")

HideawayWorkspace = React.createClass({
  mixins: [RxReactMixin]

  getInitialState: ->
    {
      content: null
    }

  getInitialRxState: ->
    { isActive: false }

  # getDefaultProps: ->
  # componentWillMount: ->

  componentDidMount: (rootNode) ->
    $(window).on "keyup", (e) =>
      if e.keyCode == 191 # "/"
        @toggle()

  toggle: ->
    @setRxState isActive: !@state.isActive

  # @param {PlaySpec} spec
  open: (spec) ->
    check "PlaySpec", spec
    content = div(null,"spec:",JSON.stringify(spec))
    @setState content: content

  # componentWillReceiveProps: (nextProps) ->
  # shouldComponentUpdate: (nextProps,nextState) ->
  # componentWillUpdate: (nextProps,nextState) ->
  # componentDidUpdate: (prevProps,prevState,rootNode) ->
  # componentWillUnmount: ->

  render: ->
    cs = cx {
      hidden: !@state.isActive
    }

    div({className: "hideaway-workspace #{cs}"},
      div({className: "container"},@state.content)
    )
})

module.exports = HideawayWorkspace