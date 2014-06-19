require 'octokit'
require 'github/issue_comment'

class ImmutableRule < Nomic::Rule
  IMMUTABLE_RULES = ['deploy_rule.rb','merge_rule.rb','listener_rule.rb', 'immutable_rule.rb']
  include GithubHelper

  def issue_comment
    @issue_comment ||= Github::IssueComment.new(@input)
  end

  def name
    "Pass if immutable rules are modified"
  end

  def pass?
    if issue_comment.valid?
      files = github_client.pull_request_files(issue_comment.repo_name,issue_comment.number)
      (IMMUTABLE_RULES & files.map(&:filename)) == 0
    else
      false
    end
  end
end
