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
    {
      accept: @normalizeOptions(data.accept)
      reject: @normalizeOptions(data.reject)
    }

  normalizeOptions: (data) ->
    for option in data
      console.log option
      if typeof option == "string"
        {text: option}
      else
        option

module.exports = QuizChooseMany