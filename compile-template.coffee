#!/usr/bin/env coffee
fs = require 'fs'

Compiler = require './lib/template-compiler'

argv = require("optimist")
  .usage("Compile a template")
  .alias("i","input")
  .describe("i","input file")
  .alias("o","output")
  .describe("o","output file")
  .alias("r","root")
  .describe("r","root path with which to compile template")
  .argv

argv.input &&
  inFile = fs.createReadStream(argv.input)

argv.output &&
  outFile = fs.createWriteStream(argv.output)

inStream = inFile || process.stdin
outStream = outFile || process.stdout

root = argv.root || argv.input

c = new Compiler(inStream,outStream,root)

c.compile (err) ->
