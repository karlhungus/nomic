module GithubHelper
  def prepare_github
    #if Rails.env.test?
    #  Octokit::Client.new :access_token => ENV['TEST_API_TOKEN']
    #else
    #  Octokit::Client.new :access_token => current_user.token
    #end
    Octokit::Clinet.new(client_id: '007deba9b949a9fb1810', client_secret: '6458ea636e4ffaaf1e2a1c70d34fb554053847ab')
  end

  def github_client
    unless @client
      @client = prepare_github
    end
    @client
  end
end
