require 'sinatra'
require 'haml'
require 'nomic'
require 'json'
require 'github_helper'
require 'github/issue_comment'

class Nomic::App < Sinatra::Base
  include GithubHelper
  use Rack::CommonLogger
  set :views, File.join(Nomic::ROOT_PATH, "views")

  @@data = {request: "no request"}
  post '/payload' do
    @@data = JSON.parse request.body.read

    if request.env['HTTP_X_GITHUB_EVENT'] == 'issue_comment'
      issue_comment = Github::IssueComment.new(@@data)

      return 'skipping' if issue_comment.comment.include?(Nomic::Rule.NOMIC_ISSUE_STRING)

      run_results = run_rules(@@data)
      CommentRule.comment(issue_comment.repo_name, issue_comment.issue_number, run_results)
      if run_results.all_pass?
        result = MergeRule.merge(issue_comment.repo_name, issue_comment.issue_number)
        DeployRule.deploy if result
      end
      { "outcome:" => run_results.to_s }.to_s
    end
  end

  get '/' do
    @data = @@data
    @rule_output = Nomic::Rule.descendants.map do |rule_class|
      rule = rule_class.new(@@data)
      "#{rule.name}: #{rule.pass}"
    end
    "<pre>#{@rule_output}</pre><br/><pre>#{@@data}</pre>"
  end

  def run_rules(issue_comment)
    Nomic::RuleRunner.run_rules
  end
end
