class DeployRule < Nomic::Rule
  module DeployEndpoint
    def self.included(app)
      require 'deploy_rule'
      app.get "/deploy" do
        response = DeployRule.deploy(Nomic.heroku_token, Nomic.github_repo, Nomic.heroku_app_name)
        "<pre>#{response.to_s}</pre>"
      end
    end
  end

  def name
    'Redeploy App if all rules pass'
  end

  def pass
    Nomic::App.send(:include, DeployEndpoint)
    true
  end

  def self.deploy(api_key, repo_name, app_name)
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
