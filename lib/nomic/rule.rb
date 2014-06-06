class Nomic::Rule
  def self.descendants
    ObjectSpace.each_object(Class).select { |klass| klass < self }
  end

  def initialize(issue_comment)
    @issue_comment = issue_comment
  end

  def name
    self.class.to_s
  end

  def run
    false
  end
end
