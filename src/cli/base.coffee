module.exports = class Base
  summary: "abstract"
  doc: "abstract"

  usage: ->
    usage = "#{@summary}\n\n#{@doc}"

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