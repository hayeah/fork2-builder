Base = require "./base"

class QuizChooseMany extends Base
  process: (cb) ->
    [rawContent, trailer] = @splitContentTrailerData()
    content = @renderContentString(rawContent)
    output = """
    <div class="quiz" data-quiz-type="choose-many" data-quiz-data="#{JSON.stringify(trailer)}">
      #{content}
    </div>
    """
    cb(null,output)

module.exports = QuizChooseMany