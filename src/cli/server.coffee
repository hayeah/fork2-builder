class Server
  summary: "Starts the fork2 web server."

  doc: """
  fork2 server $PROJECT_PATH --port $PORT
  """

  parser: ->
    return @_parser if @_parser
    usage = "#{@summary}\n\n#{@doc}"
    @_parser = require("optimist")
      .usage(usage)
      .describe("port","http port for server to listen on")
      .default("port",3000)

  run: (args) ->
    args = @parser().parse(args)
    app = require("../server/app").create()
    app.start(args.port)

module.exports = new Server()