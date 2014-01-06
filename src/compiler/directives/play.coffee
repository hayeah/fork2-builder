yaml = require 'js-yaml'
Handlebars = require "handlebars"

template = Handlebars.compile """
<div class='play alert alert-info' data-play="{{playSpec}}">
  <button class='play-button btn btn-primary'>{{caption}}</button>
</div>
"""

Base = require "./base"
class Play extends Base
  process: (cb) ->
    caption = @hash.caption || "Play"
    playSpec = yaml.safeLoad @contentString()
    output = template caption: caption, playSpec: JSON.stringify(playSpec)
    cb(null,output)


module.exports = Play