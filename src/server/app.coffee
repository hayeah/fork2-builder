# class ShowTerm extends ControllerAction
#   handle: ->
#     @res.render("terminal")

http = require("http")
express = require('express')
ehbs = require("express3-handlebars")
PTYServer = require "./pty-server"

class App
  constructor: () ->
    @setupExpress()

  setupExpress: ->
    @express = express()

    root = process.cwd()
    @express.set("root",root)

    hbsViewEngine = ehbs 
      defaultLayout: 'main'
      extname: '.hbs.html'
      layoutsDir: "#{root}/views/layouts"
      partialsDir: "#{root}/views/partials"
    
    @express.engine('.hbs.html', hbsViewEngine)

    @express.set('views', "#{root}/views")
    @express.set('view engine', '.hbs.html')
    console.log "static: #{root}"
    @express.use(express.static(root))

    @handle "get", "/", require("./actions/home")
    @handle "get", '/bootstrap', require("./actions/bootstrap_demo")
    @handle "get", "/ide/:name", require("./actions/ide")
    @handle "get", '/:name', require("./actions/slides")

    # @handle "get", "/terminal", ShowTerm
    
    

  start: (port) ->
    @server = http.createServer(@express)
    @server.listen(port || 3000)
    @socket = require("socket.io").listen(@server)
    @socket.of("/webso/pty").on "connection", (so) ->
      new PTYServer(so)
    console.log "Process #{process.pid} Listening to port #{port}"

  handle: (verb,path,action) ->
    handler = (req,res) => 
      new action(req,res,@express).handle()

    @express[verb](path, handler)

module.exports =
  create: (opts={}) -> new App(opts)