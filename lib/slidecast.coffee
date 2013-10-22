fs = require("fs")
path = require("path")
async = require("async")
# create a unique instance of handlebars compiler
hbs = require("handlebars").create()

class SlideCast
  # @params dir (Path) Path to the source of a slidecast
  # @params out (Path) Path to output the built result
  constructor: (dir,out) ->
    @dir = dir
    @out = out

  index_file_content: (cb) ->
    input_path = path.normalize(path.join(@dir,"index.hbs"))
    fs.readFile(input_path,{encoding: "utf8"},cb)

  render: (content) ->
    context = {}
    template = hbs.compile(content)
    body = template(context)

  # Transforms a slideshow
  #
  # @params cb (Function(result))  
  build: (cb) ->
    output_path = path.normalize(path.join(@out,"index.html"))
    async.waterfall [
      @index_file_content.bind(@)
      (content,cb) =>
        result = @render(content)
        fs.writeFile(output_path,result,cb)
    ], cb

module.exports = SlideCast