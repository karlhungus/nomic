class RunResults
  extend Forwardable
  def_delegators :@results, :each, :map
  def initialize(hash)
    @results = hash
  end

  def all_pass?
    @results.values.all?
  end

  def rule_names
    rules.map(&:name)
  end

  def rules
    @results.keys
  end
end
