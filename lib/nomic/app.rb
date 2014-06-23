require 'sinatra'
require 'nomic'
require 'pry'

class Nomic::App < Sinatra::Base
  use Rack::CommonLogger
  get '/test' do
    'Deployed'
  end
end
