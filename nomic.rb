require 'sinatra'
require 'json'

class Nomic < Sinatra::Base
  post '/payload' do
    push = JSON.parse(params[:payload])
    puts "I got some JSON: #{push.inspect}"
  end

  get '/' do
    erb :index
  end
end
