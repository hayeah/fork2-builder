SourceFormatter = require_test(__filename)

describe "SourceFormatter", ->
  me = (code,lang) ->
    new SourceFormatter(code,lang)

  js = ->
     code = "var i = 10;\nvar j = 40;"
     me code, "js"

  tagged_ruby = ->
    code = """
module ABC::DEF # ::mod-abc::
  include Comparable

  # ::def-foo::
  # @param test
  # @return [String] nothing
  def foo(test)
    Thread.new do |blockvar|
      ABC::DEF.reverse(:a_symbol, :'a symbol', :<=>, 'test' + ?\012)
      answer = valid?4 && valid?CONST && ?A && ?A.ord
    end.join
  end
  # ::end-def-foo::

  def [](index) self[index] end
  def ==(other) other == self end
end # ::end-mod-abc::
"""

    me code, "ruby"


  describe "#colorSyntax", ->
    beforeEach ->
      @me = js()

    it "produces a string", (done) ->
      @me.colorSyntax (err,result) ->
        result.should.be.a "string"
        done(err)

  describe "#initDOM", ->
    beforeEach (done) ->
      @me = js()
      @me.initDOM (err) =>
        @$ = @me.$
        done(err)

    it "returns a query object", ->
      @$.should.be.a "function"

    it "has a toplevel wrapper", ->
      @$div = @$("root > div")
      @$div.should.property("length",1)
      div = @$div[0]
      div.should.property("name","div")
      div.should.deep.property("attribs.class","highlight")

    describe "$lines", ->

      beforeEach ->
        @$lines = @me.$lines()

      it "has two lines", ->
        @$lines.should.property("length",2)

      it "the lines should correspond to original code", ->
        ln1 = @$lines[0]
        ln2 = @$lines[1]
        @$(ln1).text().trim().should.eql "var i = 10;"
        @$(ln2).text().trim().should.eql "var j = 40;"

  describe "#filter", ->
    beforeEach (done) ->
      @me = tagged_ruby()
      @me.initDOM done

    it "removes all lines", ->
      @me.filter [
        "none"
      ]
      @me.$lines().should.property("length",0)

    it "add lines", ->
      @me.filter [
        "none"
        {"add": "mod-abc"}
        {"add": "end-mod-abc"}
      ]
      $lines = @me.$lines()
      $lines.should.property("length",2)
      $lines.text().should.eql "module ABC::DEF\nend\n"

  describe "#normalizeDOM", ->
    beforeEach (done) ->
      @me = js()
      @me.initDOM (err) =>
        @me.normalizeDOM()
        done(err)

    it "makes line numbers a data attribute instead of id", ->
      result = @me.$.html()
      beginning = '<div class="pyg-code"><pre><span data-line="1">'
      result.should.string beginning

  describe "#format", ->
    before (done) ->
      @me = js()
      @me.format {}, (err,result) =>
        @output = result
        done(err)

    it "is a string", ->
      console.log @output





