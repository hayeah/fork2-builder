fs = require "fs"
path = require "path"

Base = require './base'

module.exports = class ShowSlideCast extends Base
  build_path: ->
    path.join(@root,"tutorials-build",@params.name)

  index_html: (cb) ->
    file = path.join(@build_path(),"index.html")
    fs.readFile file, {encoding: "utf8"}, cb

  handle: ->
    @index_html (err,content) =>
      if err
        @res.end("error reading slidecast:"+err)
      else
        @res.render("slidecast",slidecast: content)
