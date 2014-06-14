require 'httparty'

class DeployRule < Nomic::Rule
  module DeployEndpoint
    def self.included(app)
      require 'deploy_rule'
      app.get "/deploy" do
        response = DeployRule.deploy
        "<pre>#{response.to_s}</pre>"
      end
    end
  end

  def name
    'Redeploy App if all rules pass, adds /deploy endpoint for forced deploys'
  end

  def pass?
    Nomic::App.send(:include, DeployEndpoint)
    true
  end

  def execute(outcome)
    DeployRule.deploy if outcome
  end

  def self.deploy(api_key = Nomic.heroku_token, repo_name = Nomic.repo_name, app_name = Nomic.heroku_app_name)
    content = '{ "source_blob": {"url": ' + "\"https://github.com/#{repo_name}/archive/master.tar.gz\"" + ', "version": "1"}}'

    HTTParty.post("https://api.heroku.com/apps/#{app_name}/builds",
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => api_key,
        'Accept' => 'application/vnd.heroku+json; version=3'
      },
      body: content)
  end
end
