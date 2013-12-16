Base = require "./base"

prefixID = (id) -> "fn:#{@escape id}"

class FootnoteContent extends Base
  # @param id {String|Integer} The id for a footnote
  process: (id,cb) ->
    if @isBlock
      @renderContent(id,cb)
    else
      @renderReference(id,cb)

  renderReference: (id,cb) ->
    id = @escape id
    output = "<a rel='footnote' class='ref' href='##{prefixID id}'>[#{id}]</a>"
    cb(null,@safe(output))

  renderContent: (id,cb) ->
    content = @content()
    output = """
    <li class="footnote" id="#{prefixID id}">#{content}</li>
    """
    @compiler.data["footnotes"] ||= []
    @compiler.data["footnotes"].push @safe(output)
    cb(null,"")

FootnoteContent.transform = (compiler,input,cb) ->
  footnotes = compiler.data["footnotes"] || []
  if footnotes.length == 0
    return input

  html = """
  <ol class="footnotes">
    #{footnotes.join "\n"}
  </ol>
  """
  cb null, "#{input}\n#{html}"

module.exports = FootnoteContent
