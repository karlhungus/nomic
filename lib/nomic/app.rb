require 'sinatra'
require 'haml'
require 'nomic'
require 'json'
require 'byebug'
require 'httparty'

class Nomic::App < Sinatra::Base
  use Rack::CommonLogger
  set :views, File.join(Nomic::ROOT_PATH, "views")
  #set :public, File.join(Nomic::ROOT_PATH, "public")

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

  get '/test' do
    @data = @@data
    haml :index
  end


  get '/deploy_tarball' do
    #curl -n -X POST https://api.heroku.com/apps/shopify-nomic/builds -d '{"source_blob":{"url":"https://github.com/karlhungus/nomic/archive/master.tar.gz", "version": "111"}}' -H 'Accept: application/vnd.heroku+json; version=3' -H "Content-Type: application/json"
    #
    api_key = 'OjJlY2Q3NWJiLWVmYTQtNGMzMC1iMDM0LTFlMTY0NGNkNTVlNQo='
    response = HTTParty.post('https://api.heroku.com/apps/shopify-nomic/builds',
             headers: { "Content-Type" => 'application/json',
              'Authorization' => api_key,
               'Accept' => 'application/vnd.heroku+json; version=3' },
            body:
              '{ "source_blob": {"url": "https://github.com/karlhungus/nomic/archive/master.tar.gz", "version": "1"}}')
    puts "response: #{response}"
    response.to_s
  end
end
