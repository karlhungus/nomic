class Rule3 < Nomic::Rule
  include GithubHelper

  def name
    "Pass if the comments would be appropriate in Sunday school"
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
    return BadWordDetector.new.find(comment) ? false : true
  end

  def pass
    last_comments.select{|comment| approval?(comment[:body])}
  end
end
