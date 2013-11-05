# class ShowTerm extends ControllerAction
#   handle: ->
#     @res.render("terminal")

http = require("http")
express = require('express')
ehbs = require("express3-handlebars")
PTYServer = require "./pty-server"
path = require 'path'

pkgRoot = path.normalize(path.join __dirname, "../..")
serverDir = path.join pkgRoot, "src/server"
console.log "pkg root: #{pkgRoot}"

class App
  # @params options.content [Path] The directory of a built project.
  constructor: (@options) ->
    @contentRoot = @options.contentRoot
    @setupExpress()

  setupExpress: ->
    @express = express()

    @express.set("root",@contentRoot)

    hbsViewEngine = ehbs
      defaultLayout: 'main'
      extname: '.hbs.html'
      layoutsDir: "#{serverDir}/views/layouts"
      partialsDir: "#{serverDir}/views/partials"

    @express.engine('.hbs.html', hbsViewEngine)

    @express.set('views', "#{serverDir}/views")
    @express.set('view engine', '.hbs.html')
    console.log "static: #{pkgRoot}"
    @express.use(express.static(pkgRoot))

    @handle "get", "/", require("./actions/home")
    @handle "get", '/bootstrap', require("./actions/bootstrap_demo")
    @handle "get", "/terminal", require("./actions/terminal")
    @handle "get", "/ide", require("./actions/ide")
    @handle "get", '/slides', require("./actions/slides")

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
