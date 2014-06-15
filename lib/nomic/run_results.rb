class RunResults
  def initialize(hash)
    @results
  end

  def all_pass?
    results.values.all?
  end

  def rule_names
    @results.keys.map(&:name)
  end
end
