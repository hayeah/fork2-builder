class ControllerAction
  constructor: (@req,@res) ->
    @params = @req.params

  handle: ->
    throw "abstract"

class Home extends ControllerAction
  handle: ->
    @res.render('home')

class ShowTerm extends ControllerAction
  handle: ->
    @res.render("terminal")

fs = require("fs")
path = require("path")
class ShowIDE extends ControllerAction
  handle: ->
    root = __dirname
    exercises = path.join(root,"tutorials-build",@params.name,"exercises.html")
    fs.readFile exercises, {encoding: "utf8"}, (err,content) =>
      @res.render('ide',exercises: content)

class ShowBootstrapDemo extends ControllerAction
  handle: ->
    @res.render('bootstrap')

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

http = require("http")
express = require('express')
ehbs = require("express3-handlebars")

class App
  constructor: () ->
    @setupExpress()

  setupExpress: ->
    @express = express()

    @express.engine('.hbs.html', ehbs({defaultLayout: 'main',extname: '.hbs.html'}))
    @express.set('view engine', '.hbs.html')
    @express.use(express.static(__dirname))

    @handle "get", "/", Home
    @handle "get", "/terminal", ShowTerm
    @handle "get", '/ide/:name', ShowIDE
    @handle "get", '/bootstrap', ShowBootstrapDemo
    @handle "get", '/:name', ShowSlideCast

  start: (port) ->
    PTYServer = require "./server/pty-server"
    @server = http.createServer(@express)
    @server.listen(port || 3000)
    @socket = require("socket.io").listen(@server)
    @socket.of("/webso/pty").on "connection", (so) ->
      new PTYServer(so)
    console.log "Process #{process.pid} Listening to port #{port}"

  handle: (verb,path,action) ->
    handler = (req,res) -> 
      new action(req,res).handle()

    @express[verb](path, handler)

app = new App()
app.start(3000)



