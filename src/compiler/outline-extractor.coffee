# Convert toplevel headers to outline (an array of objects).
# <h1> Header 1 </h1> -> { tag: "h1", text: "Header 1", id: "header-1" }
cheerio = require "cheerio"
_s = require "underscore.string"

class OutlineExtractor
  selector: "root > h1, root > h2, root > h3, root > h4, root > h5, root > h6"
  constructor: (html) ->
    @$ = cheerio.load html

  extract: () ->
    headers = @$(@selector)
    for header in headers
      $header = @$(header)
      text = $header.text().trim()
      {
        tag: header.name,
        text: text
        id: _s.dasherize(text.toLowerCase())
      }

module.exports = OutlineExtractor