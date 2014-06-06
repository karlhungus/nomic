require 'octokit'

module GithubHelper
  def prepare_github
    Octokit::Client.new(access_token: '928f72ba85d3e9c8b62f515a56dbb945dc9aef15')
  end

  def github_client
    unless @client
      @client = prepare_github
    end
    @client
  end
end
