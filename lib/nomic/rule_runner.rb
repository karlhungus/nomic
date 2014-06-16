class Nomic::RuleRunner
  def initialize
    @rules = Nomic::Rule.descendants
  end

  def run_rules(issue_comment)
    results = @rules.reduce({}) do |hash, rule_class|
      rule = rule_class.new(issue_comment)
      hash[rule] = rule.pass?
      hash
    end

    results = RunResults.new(results)
    results.rules.sort{ |rule| rule.class == DeployRule ? -1 : 0 }.each { |rule| rule.execute(results) }
    results
  end
end
