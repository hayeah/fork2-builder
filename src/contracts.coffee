# Define types as runnable contracts combinators.
# Inspired by coffee.contracts http://disnetdev.com/contracts.coffee/

# Link list of errors to help diagnose mismatch
error = (message,val,lastError) ->
  {
    msg: message
    val: val
    next: lastError # Or(Err,All(Err))
  }

DEPTHMARKER = "=================================================="
depthMarker = (n) ->
  DEPTHMARKER.slice(0,n)

printError = (err,depth=0) ->
  return if !err
  {msg,val,next} = err
  console.log depthMarker(depth), msg, val
  if next
    errs = if next instanceof Array
      next
    else
      [next]

    for nextErr in errs
      printError(nextErr,depth+1)

  return


# Basic tests
Any = ->
  return

Nil = (val) ->
  unless val == null || val == undefined
    error "Not nil:", val

Str = (val) ->
  unless typeof val == "string"
    error "Not a string:", val

Num = (val) ->
  unless typeof val == "number"
    error "Not a number:", val

Obj = (val) ->
  unless typeof val == "object"
    error "Not an object:", val

Arr = (val) ->
  unless val instanceof Array
    error "Not an array:", val

#############
# Combinators

# Name a contract
Name = (name,test) ->
  f = (val) ->
    if err = test(val)
      return error "#{name}:", val, err
  f.contractName = name
  return f

Hash = (tests) ->
  (val) ->
    if err = Obj val
      return err

    for key, test of tests
      if err = test(val[key])
        return error "Property '#{key}':", val, err

    return

# Check all elements in an array.
List = (test,n) ->
  (val) ->
    if err = Arr(val)
      return err

    if val.length < n
      return error "Has less than #{n} elements:", val, err

    for e, i in val
      if err = test(e)
        return error "At #{i}:", val, err

    return

# Checks each element in a fixed length array.
Tuple = (tests,n) ->
  (val) ->
    if err = Arr(val)
      return err

    if n && val.length != n
      return error "Tuple arity should be #{n}:", val

    for test, i in tests
      if err = test(val[i])
        return error "At #{i}:", val, err

    return

# Nullable
Optional = (test) ->
  (val) ->
    Nil(val) || test(val)

Eql = (testVal) ->
  (val) ->
    unless val == testVal
      return error "Expects to be #{testVal}:", val

Or = (tests...) ->
  (val) ->
    errs = []
    for test in tests
      if err = test val
        name = if test.contractName
          test.contractName
        else
          "?Anon"

        errs.push error("Or #{name}:","",err)

        continue
      else
        return

    return error "Or failed:", val, errs

module.exports = {
  # basics
  Any: Any
  Nil: Nil
  Str: Str
  Num: Num
  Obj: Obj

  # combinators
  Name: Name
  Hash: Hash
  List: List
  Tuple: Tuple
  Optional: Optional
  Eql: Eql
  Or: Or

  printError: printError
}