Base = require "./base"

asset_url = (src) ->
  "/assets/#{src}"

class Image extends Base
  process: (src,cb) ->
    url = asset_url(src)

    attrs = ""

    if w = @hash.width
      attrs += " width='#{w}'"

    if h = @hash.height
      attrs += " height='#{h}'"

    output = """
    <img src='#{url}'#{attrs}/>
    """
    cb(null,@safe(output))

module.exports = Image