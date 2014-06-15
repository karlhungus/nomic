require 'test_helper'

class RuleResultsTest < Test::Unit::TestCase
  class RuleTest < Nomic::Rule
    def initialize(name)
      @name = name
    end

    def name
      @name
    end
  end
  def test_all_pass?
    assert RunResult.new({unimportant: true, unimportant2: true}).all_pass?
    refute RunResult.new({unimportant: true, unimportant2: false}).all_pass?
  end

  def test_rule_names?
    assert_equal ['foo', 'bar'], RunResult.new({RuleTest.new('foo') => true, RuleTest.new('bar')=>true}).rule_names
  end
end
