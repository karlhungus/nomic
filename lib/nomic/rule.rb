class Nomic::Rule
  NOMIC_ISSUE_STRING = 'Nomic'.freeze
  def self.descendants
    ObjectSpace.each_object(Class).select { |klass| klass < self }
  end

  def initialize(input)
    @input = input
  end

  def name
    self.class.to_s
  end

  def pass?
    false
  end

  def execute(outcome)
  end
end
