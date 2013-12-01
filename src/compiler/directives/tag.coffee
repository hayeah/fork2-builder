Base = require "./base"
class Tag extends Base
  process: (tag,cb) ->
    inner = @content()
    attributes = for key, val of @hash
      "#{key}='#{@escape val}'"

    tag_attributes = attributes.join " "
    output = "<#{tag}"
    output += " #{tag_attributes}" if attributes.length > 1
    output += ">#{inner}</#{tag}>"
    cb(null,output)

module.exports = Tag