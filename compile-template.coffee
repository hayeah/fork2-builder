#!/usr/bin/env coffee
fs = require 'fs'

Compiler = require './lib/template-compiler'

argv = require("optimist")
  .usage("Compile a template")
  .alias("i","input")
  .describe("i","input file").argv

argv.input &&
  inFile = fs.createReadStream(argv.input)

inStream = inFile || process.stdin
outStream = process.stdout

c = new Compiler(inStream,outStream)

c.compile (err) ->
