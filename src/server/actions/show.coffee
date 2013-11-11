# Show permalinked content

fs = require "fs"
path = require "path"
glob = require 'glob'

module.exports = class Show extends require('./base')
  handle: ->
    @render (err) =>
      @res.end(err) if err


  render: (cb) ->
    permalink = @params.permalink

    contentPath = @contentFilePath(permalink)
    unless contentPath
      cb("Content not found.")
      return

    type = @contentType(contentPath)
    console.log ["content-type",type]
    template = @templates[type]
    unless template
      cb("Not a valid content type to render: #{contentPath}")

    @readContent contentPath, (err,content) =>
      if err
        cb(err)
        return

      @res.render(template,content:content)

  # Map of content type to view template
  templates: {
    "deck": "slidecast"
    "lab": "ide"
  }

  readContent: (path,cb) ->
    fs.readFile path, {encoding: "utf8"}, cb

  # Gets the type of the content by examining <type> for file paths
  # of the format <permalink>.<type>.html
  #
  # @return (String) The type of a content as given by its path.
  contentType: (contentFilePath) ->
    filename = path.basename(contentFilePath)
    type = filename.split(".")[1]

  # Finds a content file that matches the permalink.
  contentFilePath: (permalink) ->
    pat = path.join(@root,permalink) + "*.html"
    candidates = glob.sync(pat)
    candidates[0] # just get the first match for now...