fs = require 'fs'
path = require 'path'

# code = (path,options) ->
#   root = this.root
#   fullpath = path.join(root,path)
#   code = new Code(fullpath)

class Code
  constructor: (@path,options) ->
  process: (cb) ->
    fs.readFile(@path,{encoding: "utf8"}, cb)

module.exports = Code
  
