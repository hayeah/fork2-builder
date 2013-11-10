# Show permalinked content

fs = require "fs"
path = require "path"
glob = require 'glob'

module.exports = class Show extends require('./base')
  handle: ->
    permalink = @params.permalink
    contentFilePath = @contentFilePath(permalink)
    unless contentFilePath
      @res.end("no content for #{permalink}")
      return
    fs.readFile contentFilePath, {encoding: "utf8"}, (err,content) =>
      if err
        @res.end("cannot read file: #{contentFilePath}")
      else
        @res.render("slidecast",content: content)

  contentFilePath: (permalink) ->
    pat = path.join(@root,permalink) + "*.html"
    candidates = glob.sync(pat)
    candidates[0] # just get the first match for now...