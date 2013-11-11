# class ShowTerm extends ControllerAction
#   handle: ->
#     @res.render("terminal")

http = require("http")
express = require('express')
ehbs = require("express3-handlebars")
PTYServer = require "./pty-server"
fs = require 'fs'
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

    # If pkgRoot/bundle exists, then use the bundled client assets.
    # Use a layout template that uses the client assets. Else use the
    # client assets in build.
    # FIXME hmmm... should probably use a --dev flag instead
    if fs.existsSync(path.join(pkgRoot,"bundle"))
      defaultLayout = "main-bundle"
    else
      defaultLayout = "main"

    hbsViewEngine = ehbs
      defaultLayout: defaultLayout
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
    # @handle "get", "/terminal", require("./actions/terminal")
    # @handle "get", "/ide", require("./actions/ide")
    # @handle "get", '/slides', require("./actions/slides")
    @handle "get", '/:permalink', require("./actions/show")

  start: (port) ->
    @server = http.createServer(@express)
    @server.listen(port || 3000)
    @socket = require("socket.io").listen(@server)
    @socket.of("/webso/pty").on "connection", (so) =>
      new PTYServer(so,@contentRoot)
    console.log "Process #{process.pid} Listening to port #{port}"

  handle: (verb,path,action) ->
    handler = (req,res) =>
      new action(req,res,@contentRoot,@express).handle()

    @express[verb](path, handler)

module.exports =
  create: (opts={}) -> new App(opts)
