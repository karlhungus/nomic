require 'sinatra'
require 'json'

class Nomic < Sinatra::Base
  post '/payload' do
    #push = JSON.parse(params[:payload])
    #puts "I got some JSON: #{push.inspect}"
    puts "Request #{params.inspect}"
  end
  get '/' do
      'Hello world!'
  end
end
