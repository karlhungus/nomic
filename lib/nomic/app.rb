require 'sinatra'
require 'haml'
require 'nomic'

class Nomic::App < Sinatra::Base
  use Rack::CommonLogger
  set :views, File.join(Nomic::ROOT_PATH, "views")
  set :public, File.join(Nomic::ROOT_PATH, "public")

  post '/payload' do
    #push = JSON.parse(params[:payload])
    #puts "I got some JSON: #{push.inspect}"
    puts 'Recieved Payload'
    puts "Request #{params.inspect}"
    params
  end

  get '/' do
    puts "test test test ------- ***********"
    haml :index
  end
end
