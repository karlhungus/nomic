require 'bad_word_detector'

class Rule2 < Nomic::Rule
  include GithubHelper

  def name
    "Pass if the comments would be appropriate in Sunday school"
  end

  def approval?(comment)
    return BadWordDetector.new.find(comment) ? false : true
  end

  def pass
    last_comments.all? {|comment| approval?(comment[:body])}
  end
end
