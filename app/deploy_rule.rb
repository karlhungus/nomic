require 'httparty'
require 'nomic'

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
  Nomic::App.send(:include, DeployEndpoint)

  def name
    'Redeploy App if all rules pass'
  end

  def pass?
    true
  end

  def execute(run_results)
    DeployRule.deploy if run_results.all_pass?
  end

  def self.deploy(api_key = Nomic.heroku_token, repo_name = Nomic.github_repo, app_name = Nomic.heroku_app_name)
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
