# Show template example.
path = require "path"
fs = require 'fs'

TemplateCompiler = require "../../compiler/template-compiler"

module.exports = class Sample extends require('./base')
  handle: (cb) ->
    name = @params.name
    templateRoot = path.join @app.pkgRoot, "doc/template-examples"
    templatePath = path.join templateRoot, "#{name}.hbs"
    template = fs.readFileSync(templatePath,encoding: "utf8")
    compiler = new TemplateCompiler(templateRoot)
    compiler.compile template, (err,output) =>
      # console.log template, err, output
      if err
        cb(err)
        return
      @render("sample",name: name, input: template, output:output)
