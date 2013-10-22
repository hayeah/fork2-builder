fs = require("fs")
path = require("path")
async = require("async")
mkdirp = require 'mkdirp'
# create a unique instance of handlebars compiler
hbs = require("handlebars").create()
marked = require 'marked'
sync = require 'sync'

markdown = (options) ->
  input = options.fn(this)
  
  # sync version
  # output = marked(input)

  # async version
  render = (cb) ->
    marked input, {}, cb
    
  output = render.sync(null)

hbs.registerHelper("markdown",markdown)
hbs.registerHelper("md",markdown)

class SlideCast
  # @params dir (Path) Path to the source of a slidecast
  # @params out (Path) Path to output the built result
  constructor: (dir,out) ->
    @dir = dir
    @out = out

  index_file_content: (cb) ->
    input_path = path.normalize(path.join(@dir,"index.hbs"))
    fs.readFile(input_path,{encoding: "utf8"},cb)

  render: (content,cb) ->
    context = {}
    template = hbs.compile(content)
    # Because handlebarjs does not support helpers that uses async functions,
    # we use the sync library here so helper functions can use fiber to make
    # an async function to behave as though it is synchronous to handlebarjs.
    sync (->
      body = template(context)
    ), cb

  # Transforms a slideshow
  #
  # @params cb (Function(result))  
  build: (cb) ->
    output_path = path.normalize(path.join(@out,"index.html"))
    async.waterfall [
      (cb) => mkdirp(@out,cb)
      (_made,cb) => @index_file_content(cb)
      (input,cb) => @render(input,cb)
      (output,cb) =>
        fs.writeFile(output_path,output,cb)
    ], cb

module.exports = SlideCast