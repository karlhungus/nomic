class Rule1 < Nomic::Rule
  include GithubHelper
  MIN_APPROVALS = 2
  APPROVAL_STRING = ":+1:"

  def name
    "Pass if there are sufficient upvotes"
  end

  def approval_comment?(comment)
    comment.include? APPROVAL_STRING
  end

  def pass
    if valid_issue?
      last_comments.select{|comment| approval_comment?(comment[:body])}.size >= MIN_APPROVALS
    else
      false
    end
  end
end
