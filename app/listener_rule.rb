require 'nomic'
require 'json'
require 'github_helper'
require 'github/issue_comment'

class ListenerRule < Nomic::Rule
  module ListenerEndpoint
    def self.included(app)
      @@last_request = {request: "no request"}
      app.post "/payload" do
        @@last_request = JSON.parse request.body.read

        if request.env['HTTP_X_GITHUB_EVENT'] == 'issue_comment'
          issue_comment = Github::IssueComment.new(@@last_request)

          return 'skipping' if issue_comment.comment.include?(Nomic::Rule::NOMIC_ISSUE_STRING)

          run_results = Nomic::RuleRunner.new.run_rules(@@last_request)
          { "outcome:" => run_results.all_pass? }.to_s
        end
      end

      app.get '/' do
        @rule_output = Nomic::Rule.descendants.map do |rule_class|
          rule = rule_class.new(@@last_request)
          "<li>#{rule.class} - #{rule.name}: #{rule.pass?}</li>"
        end
        output = "Rule Run: <ul>#{@rule_output.join('')}</ul><br/>"
        output += '<a href="/deploy">force deploy</a><br/>'
        output += '<a href="/score">current score</a><br/>'
        output += "Last Input<br/><pre>#{JSON.pretty_generate @@last_request}</pre>"
        output
      end
    end
  end
  Nomic::App.send(:include, ListenerEndpoint)

  def name
    'Add issue comment listener, run rules'
  end

  def pass?
    true
  end
end
