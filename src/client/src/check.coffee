noop = (->)

check =
  if window.DEBUG
    require("check-debug")
  else
    noop

console.log "loading check module", check

module.exports = check