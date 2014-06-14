require 'test_helper'

class RuleTest < Test::Unit::TestCase
  class RuleTest < ::Nomic::Rule
  end

  def test_descendants_retrieves_all_rule_subclasses
    assert Nomic::Rule.descendants.include?(RuleTest), 'RuleTes should be included in the list of rule descendants'
  end

  def test_default_rule_fails
    refute RuleTest.new('input').pass?
  end
end
