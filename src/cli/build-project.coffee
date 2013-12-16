path = require "path"
CourseBuilder = require "../compiler/course-builder"

class BuildProject extends require("./base")
  name: "build-project"

  summary: "Builds a given project to an output path."

  doc: """
  fork2 build-project [$PROJECT_PATH] [$OUTPUT_PATH]

  $PROJECT_PATH defaults to current path. (i.e. `pwd`)
  $OUTPUT_PATH defaults to $PROJECT_PATH/.workspace
  """

  # TODO. rebuild option should remove the otuput path before build.

  run: (args) ->
    args = @parse(args)
    inPath = args._[0] || process.cwd()
    destPath = args._[1] || path.join(inPath, ".workspace")

    builder = new CourseBuilder(inPath,destPath: destPath)
    builder.build (err) ->
      if err
        console.log "Build err:", err
      else
        console.log "Build success"

module.exports = new BuildProject()