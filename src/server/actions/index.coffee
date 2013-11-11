glob = require 'glob'
path = require 'path'
module.exports = class Show extends require('./base')
  handle: ->
    @render (err,httpcode=500) =>
      if err
        @res.status(httpcode)
        @res.end(err) if err

  render: (cb) ->
    files = glob.sync path.join(@root,"*.html")

    links = for filePath in files
      basename = path.basename(filePath)
      # <permalink>.<type>.html
      console.log basename
      re = /([^.]+)\.([^.]+)\.html$/
      m = basename.match(re)
      continue unless m
      permalink = m[1]
      link = {
        href: permalink
        text: permalink.humanize().titleize()
      }

    console.log links
    console.log ["humanize","abc".humanize]

    @res.render("index",links: links)

    cb()
    # @res.end("Show Index")