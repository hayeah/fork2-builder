glob = require 'glob'
path = require 'path'
module.exports = class Show extends require('./base')
  handle: ->
    @_handle (err,httpcode=500) =>
      if err
        @res.status(httpcode)
        @res.end(err) if err

  _handle: (cb) ->
    files = glob.sync path.join(@root,"*.html")

    links = for filePath in files
      basename = path.basename(filePath)
      # <permalink>.<type>.html
      re = /([^.]+)(\.[^.]+)?\.html$/
      m = basename.match(re)
      continue unless m
      permalink = m[1]
      link = {
        href: permalink
        text: permalink.humanize().titleize()
      }

    @render("index",links: links)

    cb()
    # @res.end("Show Index")