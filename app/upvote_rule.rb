require 'github/issue_comment'

class UpvoteRule < Nomic::Rule
  include GithubHelper
  MIN_APPROVALS = 2
  APPROVAL_STRING = ":+1:"

  def issue_comment
    @issue_comment ||= Github::IssueComment.new(@input)
  end

  def name
    "Pass if there are sufficient upvotes"
  end

  def approval_comment?(comment)
    issue_comment.comment.include? APPROVAL_STRING
  end

  def pass?
    if issue_comment.valid?
      issue_comment.last_comments.select{|comment| approval_comment?(comment[:body])}.size >= MIN_APPROVALS
    else
      false
    end
  end
end
