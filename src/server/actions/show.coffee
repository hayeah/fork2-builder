# Show permalinked content

fs = require "fs"
path = require "path"

module.exports = class Show extends require('./base')
  handle: (cb) ->
    permalink = @params.permalink

    unit = @course().findByPermalink(permalink)

    if !unit
      cb("no such page",404)
      return

    template = @templates[unit.type]

    contentPath = path.join(@root,"#{permalink}.html")
    content = fs.readFile contentPath, {encoding: "utf8"}, (err,content) =>
      if err
        cb(err,500)

      @render(template,unit: unit, content:content)

  # Map of content type to view template
  templates: {
    # "deck": "slidecast"
    # "lab": "ide"
    "page": "page"
  }