hljs = require("highlight.js")

aliases = {
  "golang": "go"
}

highlight = (code,lang,hbs=null) ->
  if lang and alias = aliases[lang]
    lang = alias

  # TODO should print an error message if a lang is not supported
  if lang
    hljs.highlight(lang, code).value
  else
    hbs.escape(code)

module.exports = highlight