class Rule1 < Nomic::Rule
  include GithubHelper
  MIN_APPROVALS = 2

  def name
    "Pass if there are sufficient upvotes"
  end

  def repo_name
    @issue_comment['repository']['full_name']
  end

  def issue_number
    @issue_comment["issue"]["number"]
  end

  def issue_comments
    github_client.issue_comments(repo_name, issue_number)
  end

  def last_comments
    issue_comments.group_by{|c| c[:user][:id]}.values.map do |user_comments|
      user_comments.max_by{|comment| comment[:updated_at]}
    end
  end

  def approval?(comment)
    comment.include? ":+1:"
  end

  def pass
    last_comments.select{|comment| approval?(comment[:body])}.size >= MIN_APPROVALS
  end
end
