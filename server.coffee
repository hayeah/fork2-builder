express = require('express')
ehbs = require("express3-handlebars")

app = express()

app.engine('.hbs.html', ehbs({defaultLayout: 'main',extname: '.hbs.html'}))
app.set('view engine', '.hbs.html')

class ControllerAction
  constructor: (@req,@res) ->
    @params = @req.params

  handle: ->
    throw "abstract"

class Home extends ControllerAction
  handle: ->
    @res.render('home')

class ShowIDE extends ControllerAction
  handle: ->
    @res.render('ide')

fs = require("fs")
path = require("path")
class ShowSlideCast extends ControllerAction
  root =  __dirname # FIXME should be App.root
  build_path: ->
    path.join(root,"tutorials-build",@params.name)

  index_html: (cb) ->
    file = path.join(@build_path(),"index.html")
    fs.readFile file,{encoding: "utf8"}, cb

  handle: ->
    @index_html (err,content) =>
      if err
        @res.end("error reading slidecast:"+err)
      else
        @res.render("slidecast",slidecast: content)

class App
  setup: (@express) ->
    @handle "get", "/", Home
    @handle "get", '/ide', ShowIDE
    @handle "get", '/:name', ShowSlideCast

  handle: (verb,path,action) ->
    handler = (req,res) -> 
      new action(req,res).handle()

    @express[verb](path, handler)

(new App()).setup(app)

app.use(express.static(__dirname))

app.listen(3000)
