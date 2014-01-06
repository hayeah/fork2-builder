# This is an ugly abstraction. It probably should just provide Rx properties, other things coordinate with hideaway by reacting to it.
{div,span} = React.DOM
cx = React.addons.classSet

RxReactMixin = require("../rx/RxReactMixin")

HideawayWorkspace = React.createClass({
  mixins: [RxReactMixin]

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

  # componentWillReceiveProps: (nextProps) ->
  # shouldComponentUpdate: (nextProps,nextState) ->
  # componentWillUpdate: (nextProps,nextState) ->
  # componentDidUpdate: (prevProps,prevState,rootNode) ->
  # componentWillUnmount: ->

  render: ->
    cs = cx {
      hidden: !@state.isActive
    }

    div({className: "hideaway-workspace #{cs}"},"workspace")
})

module.exports = HideawayWorkspace