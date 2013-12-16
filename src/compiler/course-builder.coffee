# Takes a course description (course.json) and build it.
#
# + Compile templates
# + Extract outline from templates
# + Copy assets

path = require 'path'
fs = require 'fs'
async = require 'async'
sh = require "execSync"

Course = require "../models/course"
TemplateCompiler = require "./template-compiler"
OutlineExtractor = require "./outline-extractor"

class CourseBuilder
  # @param {Path} rootPath The path to project.
  # @param {Path} opts.destPath The path to build project into.
  constructor: (rootPath,opts={}) ->
    @rootPath = rootPath
    @destPath = opts.destPath || path.join(@rootPath, ".workspace")

    metafilePath = path.join rootPath, "course.json"
    @course = Course.load(metafilePath)

  build: (cb) ->
    @sh "mkdir -p #{@destPath}"
    @rsyncAssets()

    async.waterfall [
      # compile units
      @buildUnits.bind(@)
      # output course outline (add it to course.json under the $outline key)
      # output course.json
      (outline,cb) =>
        data = @course.metadata
        data["$outline"] = outline
        @writeMetadata(data,cb)
    ], cb

  writeMetadata: (data,cb) ->
    filePath = path.join(@destPath,"course.json")
    fs.writeFile filePath, JSON.stringify(data), {encoding: "utf8"}, cb

  rsyncAssets: ->
    dest = path.join @destPath, "assets"
    from = path.join @rootPath, "assets"
    @sh "rsync -Pa --delete #{from}/ #{dest}"

  # @callback {Error,[Headers]}
  buildUnits: (cb) ->
    async.map @course.units, @buildUnit.bind(@), cb

  # @callback {Error,Headers} The extracted headers of a unit.
  buildUnit: (unit,cb) ->
    outputPath = path.join @destPath, unit.permalink+".html"
    # write output
    async.waterfall [
      # compile
      @compileUnit.bind(@,unit)

      # write to output
      (output,cb) ->
        fs.writeFile outputPath,output, {encoding: "utf8"}, (err) ->
          cb(err,output)

      # extract outline
      (output,cb) ->
        extractor = new OutlineExtractor(output)
        headers = extractor.extract()
        cb(null,headers)
    ], cb

    # return outline

  # Compile the template for a unit.
  # @callback {Error,String} The compiled output as String
  compileUnit: (unit,cb) ->
    inputPath = path.join @rootPath, unit.path
    input = fs.readFileSync(inputPath,encoding: "utf8")
    console.log "Compiling: #{unit.path}"
    compiler = new TemplateCompiler(@rootPath)
    compiler.compile(input,cb)

  sh: (cmd) ->
    console.log cmd
    code = sh.run(cmd)
    if code != 0
      throw "Abnormal exit: #{cmd}"

module.exports = CourseBuilder