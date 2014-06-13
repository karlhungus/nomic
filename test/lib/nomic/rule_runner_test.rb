require 'test_helper'

class RuleRunnerTest < Test::Unit::TestCase
  def test_run_rules_runs_all_rule_descendants
    Nomic::Rule.any_instance.expects(:pass).at_least(Nomic::Rule.descendants.size).returns(true)
    Nomic::RuleRunner.new.run_rules('input')
  end
end
