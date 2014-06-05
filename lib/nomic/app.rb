require 'sinatra'
require 'haml'
require 'nomic'
require 'json'

class Nomic::App < Sinatra::Base
  use Rack::CommonLogger
  set :views, File.join(Nomic::ROOT_PATH, "views")
  set :public, File.join(Nomic::ROOT_PATH, "public")

  post '/payload' do
    data = JSON.parse request.body.read
    data.to_json.to_s
  end

  get '/' do
    haml :index
  end
end
