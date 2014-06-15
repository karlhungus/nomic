require 'octokit'
require 'redcarpet'
require 'github_helper'
require 'github/issue_comment'

class CommentRule < Nomic::Rule
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
    comment(issue_comment.repo_name, issue_comment.number, run_results)
  end

  def comment(repo_name, pr_number, run_results)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    comment = "####{NOMIC_ISSUE_STRING}:\n"

    comment += run_results.all_pass? ? "Rules Passed, merging, deploying:\n" : "Unable to merge with failed rules:\n"
    comment += run_results.rule_names.map {|name, _| " - #{name}\n" }.join
    comment = markdown.render(comment)

    github_client.add_comment(repo_name, pr_number, comment)
  end
end
