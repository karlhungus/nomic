class Nomic::RuleRunner
  def initialize
    @rules = Nomic::Rule.descendants
  end

  def run_rules(issue_comment)
    @rules.reduce({}) do |hash, rule_class|
      rule = rule_class.new(issue_comment)
      hash[rule.name] = rule.pass
      hash
    end
  end
end
