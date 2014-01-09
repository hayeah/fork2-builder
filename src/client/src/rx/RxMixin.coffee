# Convert keyed values into reactive properties. All the reactive properties
# created are stored in `this.rx`
#
# If the initial value is `undefined`, setRx creates a property with no
# initial value.
#
# WARNING: If the property isn't subscribed to, the values pushed to bus are lost.

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
        prop = bus.toProperty()
        unless val == undefined
          prop = prop.startWith(val)
        @_rx_props[key] = prop
      else
        bus.push(val)
}