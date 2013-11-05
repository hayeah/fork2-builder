commands = {
  help: require("./help")
  "compile-template": require("./compile-template")
  "server": require("./server")
}

class CLI
  commands: commands

  constructor: ->
    argv = process.argv

    @subcommand = argv[2]
    @args = argv.slice(3)

  run: ->
    command = commands[@subcommand] || commands["help"]
    command.run(@args)

module.exports = new CLI()