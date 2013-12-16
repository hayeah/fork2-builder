OutlineExtractor = require_test(__filename)

describe "OutlineExtractor", ->
  extract = (html) ->
    extractor = new OutlineExtractor(html)
    extractor.extract()

  describe "extracted data", ->
    beforeEach ->
      html = """
      <h1> Header 1 Yo </h1>
      """

      outline = extract(html)
      @header = outline[0]

    it "text", ->
      @header.text.should.equal("Header 1 Yo")

    it "id", ->
      @header.should.property("id","header-1-yo")

    it "tag", ->
      @header.should.property("tag","h1")


  it "extracts only top level headers", ->
    html = """
    <h1> header </h1>
    <div><h1>< header 2 </h1></div>
    """
    extract(html).should.have.length(1)

  it "extracts all header types", ->
    html = """
    <h1> header </h1>
    <h2> header </h2>
    <h3> header </h3>
    <h4> header </h4>
    <h5> header </h5>
    <h6> header </h6>
    """
    extract(html).should.have.length(6)
