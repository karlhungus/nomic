require 'sinatra'
require 'haml'
require 'nomic'
require 'json'
require 'byebug'

class Nomic::App < Sinatra::Base
  use Rack::CommonLogger
  set :views, File.join(Nomic::ROOT_PATH, "views")
  set :public, File.join(Nomic::ROOT_PATH, "public")

  @@data = {request: "no request"}
  post '/payload' do
    @@data = JSON.parse request.body.read

    case request.env['HTTP_X_GITHUB_EVENT']
    when 'pull_request'
        { "mission" => "pull request success" }.to_s
    when 'pull_request_review_comment'
        { "mission" => "success" }.to_s
    end
  end

  get '/' do
    @data = @@data
    haml :index
  end
end
