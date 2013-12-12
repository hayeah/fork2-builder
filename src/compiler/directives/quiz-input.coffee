Base = require "./base"

class QuizInput extends Base
  process: (cb) ->
    [rawContent, trailer] = @splitContentTrailerData()
    trailer = @normalize(trailer)
    content = @renderContentString(rawContent)
    output = """
    <div class="quiz" data-quiz-type="input" data-quiz-data='#{JSON.stringify(trailer)}'>
      #{content}
    </div>
    """
    cb(null,output)

  normalize: (data) ->
    for entry in data
      entry.text = @renderContentString(entry.text)
      entry

module.exports = QuizInput