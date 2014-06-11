module Nomic
  extend self

  def github_token
    @github_token ||= ENV[GITHUB_API_KEY]
  end

  def github_repo
    @github_repo ||= ENV[GITHUB_REPO_NAME]
  end

  def heroku_token
    @heroku_token ||= ENV[HEROKU_API_KEY]
  end

  def heroku_app_name
    @heroku_token ||= ENV[HEROKU_APP_NAME]
  end
end
