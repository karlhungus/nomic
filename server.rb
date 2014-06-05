require 'sinatra'
require 'json'

class App < Sinatra::Base

  post '/payload' do
    push = JSON.parse(params[:payload])
    puts "I got some JSON: #{push.inspect}"
  end

  get '/' do
    "it worked"
  #  erb :index
  end

end
