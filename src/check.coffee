DEBUG = !!process.env.DEBUG

noop = (->)

check =
  if DEBUG
    require("./types")
  else
    noop

global.check = check
module.exports = check