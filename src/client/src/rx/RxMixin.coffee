# Convert keyed values into reactive properties. All the reactive properties
# created are stored in `this.rx`
#
# If the initial value is `undefined`, setRx creates a property with no
# initial value.

module.exports = RxMixin = {
  # @param {Object} props
  setRx: (props) ->
    unless @_rx_buses
      @_rx_buses = {}
      # observable properties
      @rx = @_rx_props = {}

    for key, val of props
      bus = @_rx_buses[key]
      unless bus
        bus = @_rx_buses[key] = new Bacon.Bus()
        @_rx_props[key] = bus.toProperty()
        bus.push val unless val == undefined
      else
        bus.push(val)
}