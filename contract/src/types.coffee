# Define types as runnable contracts.
# See coffee.contracts http://disnetdev.com/contracts.coffee/
# {Str,Num} = __contracts = require("contracts.js")

# Basic tests
Str = (v) ->
  typeof v == "string"

Num = (v) ->
  typeof v == "number"

# Combinators
Hash = (tests) ->
  (val) ->
    for key, test of tests
      result = test(val[key])
      return result if result == false
    return true

# Check all elements in an array.
Arr = (test) ->
  (array) ->
    for e in array
      result = test(e)
      return false if result == false
    return true

# Checks each element in a fixed length array.
Tuple = (tests...) ->
  (tuple) ->
    for test, i in tests
      result = test(tuple[i])
      return false if result == false
    return false

# Nullable
Optional = (test) ->
  (val) ->
    return true if val == null || val == undefined
    test(val)

Or = (tests...) ->
  (val) ->
    for test in tests
      result = test val
      return true if result
    return false


# A type contract is a (Value -> Boolean) function.

ShellProgram = Hash(command: Str)
OpenSpec = ShellProgram
PlaySpec = Hash(open: Arr(OpenSpec))

types = {
  Person: Person
  PlaySpec: PlaySpec
}

check = (type,value) ->
  contract = types[type]
  if contract == undefined
    throw new Error("No type defined: #{type}")
  else
    result = contract(value)
    if result != true
      console.log "Expects #{type}, but got:", value
      throw new Error("Contract violation.")
    return true

check.types = types

module.exports = check
