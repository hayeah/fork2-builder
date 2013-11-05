class Server extends require("./base")
  summary: "Starts the fork2 web server."

  doc: """
  fork2 server $PROJECT_PATH --port $PORT
  """

  configParser: ->
    @parser
      .describe("port","http port for server to listen on")
      .default("port",3000)

  run: (args) ->
    args = @parse(args)
    app = require("../server/app").create()
    app.start(args.port)

module.exports = new Server()