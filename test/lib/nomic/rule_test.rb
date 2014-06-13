require 'test_helper'

class RuleTest < Test::Unit::TestCase
  class RuleTest < ::Nomic::Rule
  end

  def test_default_rule_fails
    refute RuleTest.new('input').run
  end
end
