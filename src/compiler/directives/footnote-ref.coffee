Base = require "./base"

prefixID = (id) -> "footnote-#{id}"

class FootnoteRef extends Base
  # @param id {String|Integer} The id for a footnote
  process: (id,cb) ->
    id = @escape id
    output = "<a class='ref' href='##{prefixID id}'>[#{id}]</a>"
    cb(null,@safe(output))

module.exports = FootnoteRef
