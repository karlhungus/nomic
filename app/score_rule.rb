class ScoreRule < Nomic::Rule
  module ScoreEndpoint
    def self.included(app)
      app.get "/score" do
        pulls = github_client.pulls(Nomic.github_repo, state: 'closed')
        score = pulls.reduce({}) do |hash, pull|
          count = hash[pull.user.login] ? hash[pull.user.login] : 0
          merged = github_client.pull_merged?(Nomic.github_repo, pull.number)
          hash[pull.user.login] = merged ? count + 1 : count
          hash
        end
        score.to_s
      end
    end
  end
  Nomic::App.send(:include, ScoreEndpoint)

  def name
    'Add a Score endpoint'
  end

  def pass?
    true
  end
end
