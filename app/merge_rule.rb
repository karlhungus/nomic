require 'octokit'
require 'github/issue_comment'
require 'github_helper'
require 'nomic'

class MergeRule < Nomic::Rule
  include GithubHelper
  def name
    'Merge PR if all rules pass'
  end

  def issue_comment
    @issue_comment ||= Github::IssueComment.new(@input)
  end

  def pass?
    true
  end

  def execute(run_results)
    merge(Nomic.repo_name, issue_comment.number) if run_results.all_pass?
  end

  def merge(repo_name, pr_number)
    github_client.merge_pull_request(repo_name, pr_number)
  end
end
