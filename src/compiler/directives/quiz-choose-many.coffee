Base = require "./base"

class QuizChooseMany extends Base
  process: (cb) ->
    [rawContent, trailer] = @splitContentTrailerData()
    trailer = @normalize(trailer)
    content = @renderContentString(rawContent)
    output = """
    <div class="quiz" data-quiz-type="choose-many" data-quiz-data='#{JSON.stringify(trailer)}'>
      #{content}
    </div>
    """
    cb(null,output)

  normalize: (data) ->
    return data

module.exports = QuizChooseMany