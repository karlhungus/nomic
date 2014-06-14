require 'bad_word_detector'
require 'github/issue_comment'

class Rule2 < Nomic::Rule
  include GithubHelper

  def issue_comment
    @issue_comment ||= Github::IssueComment.new(@input)
  end

  def name
    "Pass if the comments would be appropriate in Sunday school"
  end

  def approval?(comment)
    return BadWordDetector.new.find(comment) ? false : true
  end

  def pass?
    issue_comment.last_comments.all? {|comment| approval?(comment[:body])}
  end
end
