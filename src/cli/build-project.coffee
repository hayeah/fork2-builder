path = require "path"
glob = require 'glob'
Course = require "../models/course"

class BuildProject extends require("./base")
  name: "build-project"

  summary: "Builds a given project to an output path."

  doc: """
  fork2 build-project $PROJECT_PATH [$OUTPUT_PATH]

  $OUTPUT_PATH defaults to $PROJECT_PATH/.workspace
  """

  # TODO. rebuild option should remove the otuput path before build.

  run: (args) ->
    args = @parse(args)
    inPath = args._[0]
    outPath = args._[1]

    if !inPath
      @help()
      return

    if !outPath
      outPath = path.join inPath, ".workspace"

    # TODO check if input path is valid
    @inPath = @ensureTrailingSlash(inPath)
    @outPath = @ensureTrailingSlash(outPath)

    @course = Course.load(path.join(@inPath,"course.json"))

    @sh("mkdir -p #{@outPath}")
    @compileAll()
    @cp("course.json")

  # cp file at path from source to output
  cp: (file) ->
    from = path.join @inPath, file
    to = path.join @outPath, file
    @sh "cp #{from} #{to}"

  ensureTrailingSlash: (dir) ->
    # path.normalize ensures that repeating "//" become "/".
    # Doing the following we ensure a trailing slash.
    path.normalize(dir + "/")

  compileAll: ->
    for unit in @course.units
      input = path.join @inPath, unit.path
      output = path.join @outPath, unit.permalink+".html"
      @compileTemplate(input,output)

  compileTemplate: (inFile,outFile) ->
    cmd = "fork2 compile-template --root='#{@inPath}' --input='#{inFile}' --output='#{outFile}'"
    @sh cmd

module.exports = new BuildProject()