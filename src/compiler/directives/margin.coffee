Base = require "./base"
class Margin extends Base
  process: (cb) ->
    if !@isBlock
      cb("Need block content.")

    content = @content()
    output = """
    <div class="margin-box"><div class="margin-box-content">#{content}</div></div>
    """
    cb(null,output)

module.exports = Margin