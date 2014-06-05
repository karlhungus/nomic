require 'sinatra'
require 'haml'
require 'nomic'

class Nomic::App < Sinatra::Base
  use Rack::CommonLogger
  set :views, File.join(Nomic::ROOT_PATH, "views")
  set :public, File.join(Nomic::ROOT_PATH, "public")

  post '/payload' do
    puts "Request: #{params}"
    params
  end

  get '/' do
    haml :index
  end
end
