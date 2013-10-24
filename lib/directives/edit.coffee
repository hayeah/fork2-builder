path = require 'path'
fs = require 'fs'
async = require 'async'

module.exports = class Edit
  constructor: (@options) ->
    @hbs = @options.hbs

  # Specifies file or files to show in Editor for edit and evaluation.
  # If a runner command is given via the `run` option, that is used
  # to carry out the evaluation.
  #
  # In the case that a single file is given, the run command may
  # be ommitted, and a default is use to exec the given type of file.
  #
  # @param filePath (String) the path of the source file to edit.
  # @option run (String) command to run.
  #
  # Outputs a JSON object that the IDE uses to show the file and configure
  # the runner.
  # 
  # Example:
  #
  # {type: "edit"
  #  files: [{path: "hello.rb",content: "..."}]
  #  test: ...
  #  run: "ruby hello.rb"}
  process: (@filePath,@options,cb) ->
    @fullPath = path.join(@options.root,@filePath)

    async.waterfall [
      (cb) => fs.readFile @fullPath,{encoding: "utf8"}, cb
      (content,cb) =>
        data = {
          type: "edit"
          file: {path: @filePath, content: content}
          run: @options.run
        }
        cb(null,@ideActionTag(data))
    ], cb

  # TODO Pull these methods into a base class.
  #
  # Escapes a string to make it HTML safe. See note on `safe` about marking
  # a string as safe.
  escape: (str) ->
    @hbs.escape(str)

  # Marks a string as HTML safe.
  #
  # NOTE hbs tests if a string needs escaping by testing whether it is an instance of
  # a SafeString specific the the current instance of handlebars. This is why we need
  # to proxy the safe string factory via the particular instance of handlebars we are using
  # instead of the default handlebars instance.
  safe: (str) -> 
    @hbs.safe(str)

  # Builds a script tag that embeds a json data.
  # @return (String) a html safe string
  ideActionTag: (data) ->
    json = @escape JSON.stringify(data)
    @safe "<script class='ide-action' type='text/json'>#{json}</script>"