module.exports = class Base
  # The subcommand name used to invoke a command
  name: "abstract"

  # One line summary to describe this command.
  summary: "abstract"

  # DocString to describe this command.
  doc: "abstract"

  usage: ->
    usage = "#{@summary}\n\n#{@doc}"

  # Subclass should override this to configure its command line parser.
  configParser: ->
    throw "abstract"

  # optimist has only a singleton parser. We need to make sure that the subcommands don't step on each other.
  buildParser: ->
    return @parser if @parser
    usage = "#{@summary}\n\n#{@doc}"
    @parser = require("optimist").usage(usage)
    @configParser()

  parse: (args) ->
    @parser.parse(args)

  help: ->
    @buildParser()
    @parser.showHelp()