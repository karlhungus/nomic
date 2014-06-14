require 'test_helper'

class RuleRunnerTest < Test::Unit::TestCase
  def test_run_rules_runs_all_rule_descendants_and_executes_them_with_outcome
    Nomic::Rule.any_instance.expects(:pass?).at_least(Nomic::Rule.descendants.size).returns(true)
    Nomic::Rule.any_instance.expects(:execute).at_least(Nomic::Rule.descendants.size).with(true)
    Nomic::RuleRunner.new.run_rules('input')
  end
end
