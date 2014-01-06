# Bind component state with Bacon reactive properties.
RxMixin = require("./RxMixin")

RxReactMixin = {
  componentWillMount: ->
    if @getInitialRxState
      state = @getInitialRxState()
      @setRxState(state)

  # create reactive properties and set state.
  setRxState: (props) ->
    @setState(props)
    RxMixin.setRx.call(@,props)
}

module.exports = RxReactMixin