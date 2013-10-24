assert = require "assert"
should = require('should')

describe "Foo", ->
  it "should foobar", ->
    assert(true)

  it "should baz", ->
    assert(false)

  it "uses should", ->
    o = {foo: 3}
    o.should.have.property("foo","bar")