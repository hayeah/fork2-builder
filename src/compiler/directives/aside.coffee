Base = require "./base"
Handlebars = require "handlebars"

template = Handlebars.compile """
<div class="panel panel-default">
  <div class="panel-heading">{{title}}</div>
  <div class="panel-body">{{~{content}~}}</div>
</div>
"""

class Aside extends Base
  process: (title,cb) ->
    content = @content()
    output = template(title: title, content: content)
    cb(null,output)

module.exports = Aside