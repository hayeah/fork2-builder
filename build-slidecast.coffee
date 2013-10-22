#!/usr/bin/env coffee
argv = require("optimist")
  .usage("Build slidecast")
  .demand(["i","o"])
  .alias("i","input")
  .alias("o","output")
  .describe("o","output directory")
  .describe("i","input directory")
  .argv

SlideCast = require("./lib/slidecast")


slidecast = new SlideCast(argv.input,argv.output)

slidecast.build (err) ->
  if err
    console.log err
