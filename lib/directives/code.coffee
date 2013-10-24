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
        source = @hbs.Utils.escapeExpression source
        html = "<pre><code>#{source}</code></pre>"
        cb(null,new @hbs.SafeString(html))
    ], cb
    


module.exports = Code
  
