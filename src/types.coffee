# A type contract is a (Value -> Boolean) function.

{Name,Hash,List,Str,Num,Eql,printError} = C = require("./contracts")

# @typedef {{command: String, type: "repl"}} ShellProgram
ShellProgram = Name "ShellProgram", Hash(command: Str, type: Eql("repl"))

# @typedef {ShellProgram} OpenSpec
OpenSpec = Name "OpenSpec", ShellProgram

# @typedef {{open: Array.<OpenSpec>} PlaySpec
PlaySpec = Name "PlaySpec", Hash(open: List(OpenSpec))

types = {
  OpenSpec: OpenSpec
  PlaySpec: PlaySpec
}

check = (type,value) ->
  contract = types[type]
  if contract == undefined
    throw new Error("No type defined: #{type}")
  else
    if err = contract(value)
      printError err
      throw new Error("Contract violation.")

check.types = types

module.exports = check
