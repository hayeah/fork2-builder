path = require 'path'

class Server extends require("./base")
  name: "server"

  summary: "Build and run a project."

  doc: """
  fork2 server [PROJECT_PATH] [--port PORT]

  PROJECT_PATH defaults to curren working directory.

  Running this command is equivalent to running,

    `fork2 build-project $PROJECT_PATH $PROJECT_PATH/.workspace`

  then running,

    `fork2 run $PROJECT_PATH/.workspace`
  """

  configParser: ->
    @parser
      .describe("port","http port for server to listen on")
      .default("port",3000)

  run: (args) ->
    args = @parse(args)

    @projectPath = path.normalize(args._[0] || process.cwd())
    @workspacePath = path.join @projectPath, ".workspace"

    @buildProject()
    @runProject(args.port)

  runProject: (port) ->
    @sh("fork2 run #{@workspacePath} --port=#{port}")

  buildProject: ->
    @sh("fork2 build-project #{@projectPath}")

module.exports = new Server()