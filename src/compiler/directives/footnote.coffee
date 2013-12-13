Base = require "./base"

prefixID = (id) -> "footnote-#{@escape id}"

class FootnoteContent extends Base
  # @param id {String|Integer} The id for a footnote
  process: (id,cb) ->
    if @isBlock
      @renderContent(id,cb)
    else
      @renderReference(id,cb)

  renderReference: (id,cb) ->
    id = @escape id
    output = "<a class='ref' href='##{prefixID id}'>[#{id}]</a>"
    cb(null,@safe(output))

  renderContent: (id,cb) ->
    content = @content()
    output = """
    <div class="ref-content hidden" id="#{prefixID id}">#{content}</div>
    """
    cb(null,@safe(output))

module.exports = FootnoteContent
