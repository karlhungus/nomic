require 'octokit'

module GithubHelper
  def prepare_github
    Octokit::Client.new(access_token: Nomic.github_token)
  end

  def github_client
    unless @client
      @client = prepare_github
    end
    @client
  end
end
