cmds = [
  require("./help")
  require("./compile-template")
  require("./build-project")
  # require("./server")
  require("./run")
]

# register subcommands
commands = {}
for cmd in cmds
  commands[cmd.name] = cmd

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