require 'sinatra'
require 'json'

post '/payload' do
  push = JSON.parse(params[:payload])
  puts "I got some JSON: #{push.inspect}"
end

get '/' do
  erb :index
end
