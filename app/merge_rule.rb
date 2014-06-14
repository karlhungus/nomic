require 'octokit'
require 'github/issue_comment'

class MergeRule < Nomic::Rule
  def name
    'Merge PR if all rules pass'
  end

  def issue_comment
    @issue_comment ||= Github::IssueComment.new(@input)
  end

  def pass?
    true
  end

  def execute(outcome)
    MergeRule.merge(Nomic.repo_name, issue_comment.number) if outcome
  end

  def self.merge(repo_name, pr_number)
    github_client.merge_pull_request(repo_name, pr_number)
  end
end
