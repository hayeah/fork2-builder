noop = (->)

check =
  if window.DEBUG
    require("check-debug")
  else
    noop

module.exports = check