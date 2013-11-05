path = require "path"
glob = require 'glob'

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
    inPath = @ensureTrailingSlash(inPath)
    outPath = @ensureTrailingSlash(outPath)

    @rsyncToOutput(inPath,outPath)

    @compileTemplates(inPath,outPath)

  ensureTrailingSlash: (dir) ->
    # path.normalize ensures that repeating "//" become "/".
    # Doing the following we ensure a trailing slash.
    path.normalize(dir + "/")

  compileTemplates: (inDir,outDir) ->
    pat = path.join(inDir,"**/*.hbs")
    options = {}
    matches = glob.sync pat, options
    for template in matches
      basename = path.basename(template,".hbs")
      output = path.join(outDir,basename) + ".html"
      cmd = "fork2 compile-template --root='#{inDir}' --input='#{template}' --output='#{output}'"
      @sh(cmd)

  # copy all project content to output path
  rsyncToOutput: (inPath,outPath) ->
    inPath = @ensureTrailingSlash(inPath)
    # with the trailing slash in inPath, rsync copies the content of inPath to
    # outPath without creating a subdirectory in outPath.
    code = @sh("rsync --exclude '.workspace' -Pa #{inPath} #{outPath}")


module.exports = new BuildProject()