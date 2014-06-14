require 'octokit'
require 'redcarpet'
require 'github/issue_comment'

class CommentRule < Nomic::Rule
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
    #TODO: need run results
    CommentRule.comment(issue_comment.repo_name, issue_comment.number, outcome, outcome) if outcome
  end

  def self.comment(repo_name, pr_number, outcome, run_results)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    comment = "####{NOMIC_ISSUE_STRING}:\n"

    comment += outcome ? "Rules Passed, merging, deploying:\n" : "Unable to merge with failed rules:\n"
    comment += run_results.map {|rule, _| " - #{rule}\n" }.join
    comment = markdown.render(comment)

    github_client.add_comment(repo_name, pr_number, comment)
  end
end
