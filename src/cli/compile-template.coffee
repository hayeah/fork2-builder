fs = require 'fs'

TemplateCompiler = require '../compiler/template-compiler'

class CompileTemplate
  summary: "Compiles a single content template."

  doc: """
  fork2 compile-template -i INPUT -o OUTPUT -r PROJECT_ROOT
  """

  constructor: ->
    @parser = require("optimist")
      .usage("Compile a template")
      .alias("i","input")
      .describe("i","input file")
      .alias("o","output")
      .describe("o","output file")
      .alias("r","root")
      .describe("r","root path with which to compile template")

  run: (args) ->
    args = @parser.parse(args)

    args.input &&
      inFile = fs.createReadStream(args.input)

    args.output &&
      outFile = fs.createWriteStream(args.output)

    inStream = inFile || process.stdin
    outStream = outFile || process.stdout

    root = args.root || args.input

    c = new TemplateCompiler(inStream,outStream,root)

    c.compile (err) ->
      console.log err if err

  help: ->
    console.log @summary
    console.log @doc
    @parser.help()


module.exports = new CompileTemplate()
