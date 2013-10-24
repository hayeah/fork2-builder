#!/usr/bin/env coffee
fs = require 'fs'

Compiler = require './lib/template-compiler'

argv = require("optimist")
  .usage("Compile a template")
  .alias("i","input")
  .describe("i","input file")
  .alias("r","root")
  .describe("r","root path with which to compile template")
  .argv

argv.input &&
  inFile = fs.createReadStream(argv.input)

inStream = inFile || process.stdin
outStream = process.stdout

root = argv.root || argv.input

c = new Compiler(inStream,outStream,root)

c.compile (err) ->
