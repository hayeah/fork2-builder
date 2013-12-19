TaggedSource = require_test(__filename)

sample_source = """
defmodule MyList do # ::mylist::
  # ::len::
  def len([]), do: 0
  def len([_head | tail]), do: 1 + len(tail) # ::len-2::
  # ::len-end::

  # ::square::
  def square([]), do: []
  def square([ head | tail ]), do: [ head*head | square(tail) ] # ::square-2::
  # ::end-square::
end # ::end-mylist::
"""

describe "TaggedSource", ->
  beforeEach ->
    @me = new TaggedSource(sample_source,"#")

  it "extract tags from lines", ->
    @me.tags.should.eql {
      'mylist': 0,
      len: 1,
      'len-2': 3,
      'len-end': 4,
      square: 6,
      'square-2': 8,
      'end-square': 9
      "end-mylist": 10
    }

  it "get line numbers between tags", ->
    range = @me.betweenTags("len","len-end")
    range.should.eql [1..4]

  it "get line numbers between tags (exclusive)", ->
    range = @me.betweenTags("len:1","len-end:-1",false)
    range.should.eql [2..3]

  describe "output", ->
    beforeEach ->
      @lines = @me.getOutputLines()

    it "strips out lines that are empty except for tagging", ->
      @lines.should.length(7)
      @lines[1].should.match /def len\(\[\]\)/

  describe "#at", ->
    it "gets the position of a tag", ->
      @me.at("len-2").should.eql 3

    it "gets 3 lines after a tag", ->
      @me.at("len-2:+3").should.eql 6

    it "gets 3 lines before a tag", ->
      @me.at("len-2:-3").should.eql 0

    it "raises error if tag doesn't exist", ->
      (=> @me.at("no-such-tag")).should.throw(/^Tag not found/)

    it "raises error if tag modifier is gibberish", ->
      (=> @me.at("len-2:gibberish")).should.throw(/^Tag position modifier is not a number/)

    it "raises error if tag with modifier is out of range", ->
      (=> @me.at("mylist:-1")).should.throw(/^Tag position is outside the range/)
      (=> @me.at("end-mylist:1")).should.throw(/^Tag position is outside the range/)

  describe "#addr", ->
    it "gets the position of a tagged position", ->
      @me.addr("len").should.eql [1]

    it "gets the range between two tags", ->
      @me.addr("len,len-end").should.eql [1..4]

    it "gets the range between two modified tags", ->
      @me.addr("len:1,len-end:-1").should.eql [2..3]

  describe "line selection", ->
    beforeEach ->
      @me.selectNone()

    it "deselects everything", ->
      @me.selectedLines.should.eql []

    it "selects addressed lines", ->
      @me.select("len-2")
      @me.select("square-2")
      @me.selectedLines.should.eql [3,8]

    it "combines selected addresses", ->
      @me.select("len-2")
      @me.select("len,len-end")
      @me.selectedLines.sort().should.eql [1..4]

    it "deselct lines", ->
      @me.select("len,len-end")
      @me.deselect("len-2")
      @me.selectedLines.sort().should.eql [1,2,4]




