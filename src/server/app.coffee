# class ShowTerm extends ControllerAction
#   handle: ->
#     @res.render("terminal")

require "../check"

http = require("http")
express = require('express')
ehbs = require("express3-handlebars")
# PTYServer = require "./pty-server"
fs = require 'fs'
path = require 'path'

pkgRoot = path.normalize(path.join __dirname, "../..")
serverDir = path.join pkgRoot, "src/server"
console.log "pkg root: #{pkgRoot}"

Socket = require("socket.io")
PingServer = require("./PingServer")
PTYServer = require("./PTYServer")

USE_BUNDLE = !!process.env.BUNDLE

class App
  # @params options.content [Path] The directory of a built project.
  constructor: (@options) ->
    @contentRoot = @options.contentRoot
    @pkgRoot = pkgRoot
    @setupExpress()

  setupExpress: ->
    @express = express()

    @express.use(express.favicon())

    @express.set("root",@contentRoot)

    hbsViewEngine = ehbs
      defaultLayout: "app"
      extname: '.hbs.html'
      layoutsDir: "#{serverDir}/views/layouts"
      partialsDir: "#{serverDir}/views/partials"

    @express.engine('.hbs.html', hbsViewEngine)

    @express.set('views', "#{serverDir}/views")
    @express.set('view engine', '.hbs.html')

    @express.use(express.compress())
    # TODO disable this...? can I still get source map to work? ya i think so. It's inline from browserify
    # @express.use(express.static(pkgRoot))

    clientRoot = path.join pkgRoot, "src/client"

    staticPath =
      if USE_BUNDLE
        path.join clientRoot, "bundle"
      else
        path.join clientRoot, "build"

    console.log "static: #{staticPath}"
    @express.use(express.static(staticPath))


    assetsPath = path.resolve(path.join @contentRoot, "assets")
    console.log "assets: #{assetsPath}"
    @express.use("/assets",express.static(assetsPath))

    @handle "get", "/", require("./actions/index")
    @handle "get", "/mobile", require("./actions/mobile")
    @handle "get", '/bootstrap', require("./actions/bootstrap_demo")
    @handle "get", '/react', require("./actions/react_sandbox")
    # @handle "get", "/terminal", require("./actions/terminal")
    @handle "get", '/sample/:name', require("./actions/sample")
    @handle "get", '/uitest/:name', require("./actions/uitest")
    @handle "get", '/:permalink', require("./actions/show")

  start: (port) ->
    @server = http.createServer(@express)
    @server.listen(port || 3000)
    @socket = Socket.listen(@server)
    @socket.on "connection", (so) =>
      # new PingServer(so)
      new PTYServer(so)

    console.log "Process #{process.pid} Listening to port #{port}"

  handle: (verb,path,action) ->
    handler = (req,res) =>
      (new action(req,res,this)).process()

    @express[verb](path, handler)

module.exports =
  create: (opts={}) -> new App(opts)
