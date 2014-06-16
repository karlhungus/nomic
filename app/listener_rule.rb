require 'nomic'
require 'json'
require 'github_helper'
require 'github/issue_comment'

class ListenerRule < Nomic::Rule
  module ListenerEndpoint
    def self.included(app)
      @@data = {request: "no request"}
      app.post "/payload" do
        @@data = JSON.parse request.body.read

        if request.env['HTTP_X_GITHUB_EVENT'] == 'issue_comment'
          issue_comment = Github::IssueComment.new(@@data)

          return 'skipping' if issue_comment.comment.include?(Nomic::Rule::NOMIC_ISSUE_STRING)

          run_results = Nomic::RuleRunner.new.run_rules(@@data)
          { "outcome:" => run_results.all_pass? }.to_s
        end
      end

      app.get '/' do
        @data = @@data
        @rule_output = Nomic::Rule.descendants.map do |rule_class|
          rule = rule_class.new(@@data)
          "#{rule.name}: #{rule.pass?}\n"
        end
        "<pre>#{@rule_output}</pre><br/><pre>#{JSON.pretty_generate @@data}</pre>"
      end
    end
  end
  Nomic::App.send(:include, ListenerEndpoint)

  def name
    'Add issue comment listener for issue commets, run rules'
  end

  def pass?
    true
  end
end
