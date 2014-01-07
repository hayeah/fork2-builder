{printError} = C = Contracts = require_test(__filename)
perr = printError

describe "Contracts", ->
  match = (test,value) ->
    expect(test(value)).to.be.an("undefined")

  fail = (test,value) ->
    expect(test(value)).to.not.be.an("undefined")

  describe "Any", ->
    it "matches anything", ->
      match C.Any, 1
      match C.Any, "a"
      match C.Any, {}

  describe "Num", ->
    it "matches a number", ->
      match C.Num, 1
      match C.Num, -1

    it "failes otherwise", ->
      fail C.Num, "string"
      fail C.Num, []
      fail C.Num, {}

  describe "Nil", ->
    beforeEach ->
      @t = C.Nil

    it "matches null", ->
      match @t, null

    it "matches undefined", ->
      match @t, undefined

    it "fails others", ->
      fail @t, 1
      fail @t, "a"

  describe "Str", ->
    it "matches a string", ->
      match C.Str, "string"
      match C.Str, ""

    it "failes otherwise", ->
      fail C.Str, 1
      fail C.Str, []
      fail C.Str, {}

  describe "Obj", ->
    it "matches an object", ->
      match C.Obj, {}

    it "failes otherwise", ->
      fail C.Obj, "string"
      fail C.Obj, 1

  describe "Hash", ->
    beforeEach ->
      @t = C.Hash(num: C.Num, str: C.Str)

    it "matches all properties", ->
      match @t, {num: 1, str: "str"}

    it "allows extra properties", ->
      match @t, {num: 1, str: "str", obj: {}}

    it "fails if any property is missing", ->
      fail @t, {obj: {}}
      fail @t, {num: 1}
      fail @t, {str: "a"}

    it "fails if property fails to match", ->
      fail @t, {num: 1, str: 1}
      fail @t, {num: "b", str: "a"}

  describe "List", ->
    beforeEach ->
      @t = C.List(C.Num)
      @tmin = C.List(C.Num,1)

    it "matches empty array", ->
      match @t, []

    it "matches if all elements in array matches", ->
      match @t, [1,2,3]

    it "fails empty array if a minimum length is given", ->
      fail @tmin, []

    it "fails if not an array", ->
      fail @t, "abc"

    it "fails if anything in an array does not match", ->
      fail @t, [1,2,3,[]]

  describe "Tuple", ->
    beforeEach ->
      @t = C.Tuple([C.Str,C.Num])
      @t2 = C.Tuple([C.Str,C.Num],2)

    it "matches if all elements matches", ->
      match @t, ["a",1]

    it "accepts extra elements", ->
      match @t, ["a",1,3]

    it "fails if arity is specified and tuple mismatches", ->
      fail @t2, ["a",1,3]

  describe "Eql", ->
    beforeEach ->
      @t = C.Eql("abc")

    it "matches if value passes equality test", ->
      match @t, "abc"

    it "fails if not eql", ->
      fail @t, "not-abc"

  describe "Or", ->
    beforeEach ->
      @t = C.Or(C.Name("Index",C.Num),C.Name("Tag",C.Str))

    it "matches a number", ->
      match @t, 10

    it "matches a string", ->
      match @t, "abc"

    it "fails otherwise", ->
      console.log err = @t([])
      perr err
      fail @t, []
      fail @t, {}

