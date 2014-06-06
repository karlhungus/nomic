class Rule1 < Nomic::Rule
  include GithubHelper

  def name
    "Alawys fail"
  end

  def pass
    false
  end
end
