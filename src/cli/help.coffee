version = require '../version'

class Help
  summary: "Show detailed help for a command"

  run: (args) ->
    @help()

  help: ->
    console.log "Fork2 Version #{version}"
    cli = require("./cli")
    console.log "The available commands are:\n"
    for name, command of cli.commands
      console.log "  #{name} - #{command.summary}"

module.exports = new Help()
