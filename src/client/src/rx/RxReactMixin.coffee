# Bind component state with Bacon reactive properties.
RxMixin = require("./RxMixin")

RxReactMixin = {
  componentWillMount: ->
    if @getInitialRxState
      state = @getInitialRxState()
      @setRxState(state)

  # create reactive properties and set state.
  setRxState: (props,cb) ->
    @setState(props,cb)
    RxMixin.setRx.call(@,props)
}

module.exports = RxReactMixin