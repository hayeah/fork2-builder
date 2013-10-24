fs = require 'fs'
path = require 'path'
async = require 'async'

class Code
  constructor: (@path,@options) ->
    @hbs = @options.hbs

  process: (cb) ->
    async.waterfall [
      (cb) => fs.readFile @path,{encoding: "utf8"}, cb
      (source,cb) =>
        source = @hbs.escape source
        html = "<pre><code>#{source}</code></pre>"
        cb(null,@hbs.safe(html))
    ], cb
    


module.exports = Code
  
