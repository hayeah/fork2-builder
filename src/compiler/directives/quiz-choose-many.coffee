Base = require "./base"

class QuizChooseMany extends Base
  process: (cb) ->
    [rawContent, trailer] = @splitContentTrailerData()
    trailer = @normalize(trailer)
    content = @renderContentString(rawContent)
    output = """
    <div class="quiz" data-quiz-type="choose-many" data-quiz-data='#{@escape JSON.stringify(trailer)}'>
      #{content}
    </div>
    """
    cb(null,output)

  normalize: (data) ->
    for entry in data
      entry.text = @renderContentString(String(entry.text))
      entry

module.exports = QuizChooseMany