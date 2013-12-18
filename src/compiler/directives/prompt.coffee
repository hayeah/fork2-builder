Base = require "./base"
Handlebars = require "handlebars"

template = Handlebars.compile """
<div class="prompt">
  {{~#each rows}}
  <div class="prompt-row">
    <div class="prompt-input"><span class="prompt-prompt">{{../prompt}}</span> {{input}}</div>
    <div class="prompt-output">{{output}}</div>
  </div>
  {{~/each}}
</div>
"""

class Prompt extends Base
  process: (prompt,cb) ->
    sections = @splitSections()
    i = 0
    rows = []
    while i < sections.length
      input = sections[i]
      output = sections[i+1]
      rows.push {input: input.trim(), output: output.trim()}
      i += 2

    output = template(rows: rows, prompt: prompt).trim()
    cb(null,output.trim())

module.exports = Prompt