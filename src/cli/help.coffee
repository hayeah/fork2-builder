version = require '../version'

class Help
  summary: "Show detailed help for a command"

  run: (args) ->
    cli = require("./cli")
    @commands = cli.commands

    commandName = args[0]
    if command = @commands[commandName]
      command.help()
    else
      @help()

  help: ->
    console.log "Fork2 Version #{version}"
    console.log "The available commands are:\n"
    for name, command of @commands
      console.log "  #{name} - #{command.summary}"

    console.log "\n`fork2 help <command>` to show detailed help for a subcommand."

module.exports = new Help()
