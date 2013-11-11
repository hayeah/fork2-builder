path = require 'path'

class Run extends require("./base")
  name: "run"

  summary: "Runs a built project."

  doc: """
  fork2 run [PROJECT_BUILD_PATH] [--port PORT]

  PROJECT_BUILD_PATH defaults to curren working directory
  """

  configParser: ->
    @parser
      .describe("port","http port for server to listen on")
      .default("port",3000)

  run: (args) ->
    args = @parse(args)
    contentRoot = path.normalize(args._[0] || process.cwd())
    @startServer(contentRoot,args.port)

  startServer: (root,port) ->
    app = require("../server/app").create
      contentRoot: root
    app.start(port)


module.exports = new Run()
