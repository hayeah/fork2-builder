Base = require "./base"

class FootnoteContent extends Base
  process: (id,cb) ->
    if !@isBlock
      cb("Need block content.")

    content = @content()
    fid = "footnote-#{@escape id}"
    output = """
    <div class="ref-content" id="#{fid}">[#{id}]: #{content}</div>
    """
    @appendToEnd(output)
    cb(null,"")

module.exports = FootnoteContent
