require 'sinatra'
require 'haml'
require 'nomic'
require 'json'
require 'byebug'
require 'httparty'

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

  get '/deploy_tarball' do
    #curl -X POST \
    #  -H "Accept: application/vnd.heroku+json; version=3" \
    #  -H "Content-Type: application/json" \
    #  -d '{"slug":"d969e0b3-9892-3113-7653-1aa1d1108bc3"}' \
    #  -n https://api.heroku.com/apps/example/releases
    #location_of_tgz = 'https://github.com/karlhungus/nomic/archive/7380385c1703a202d84d3d36589eae8b3b8560de.tar.gz'
    location_of_tgz = 'nomic-master.tar.gz'

    #request slug allocation

    puts 'Requesting slug allocation'
    api_key = 'OjJlY2Q3NWJiLWVmYTQtNGMzMC1iMDM0LTFlMTY0NGNkNTVlNQo='
    @result = HTTParty.post('https://api.heroku.com/apps/shopify-nomic/slugs',
                            headers: { "ContentType" => 'application/json',
                              'Authorization' => api_key,
                               'Accept' => 'application/vnd.heroku+json; version=3' },
                            body:
                              { "process_types" => {"web" => "ruby-2.0.0/bin/ruby server.rb"}})
    puts 'results of request slug allocaiton'
    puts @result
    puts 'fetching blob'
#    debugger
    blob_response = @result['blob']
    puts 'blob response'
    puts blob_response
    puts 'blob response above'
    #push slug to server
    tgz = File.new(location_of_tgz, 'rb').read
    put_response = HTTParty.put('https://api.heroku.com/apps/shopify-nomic/releases',
                 headers: {"Content-Type" => "application/json",
                   "Accept" => "application/vnd.heroku+json; version=3",
                   'Authorization' => api_key},
                 body: tgz)
    puts 'results of put request'
    puts put_response
    puts 'put response above'
    #release slug
    #curl -X POST \
    #-H "Accept: application/vnd.heroku+json; version=3" \
    #-H "Content-Type: application/json" \
    #-d '{"slug":"d969e0b3-9892-3113-7653-1aa1d1108bc3"}' \
    #-n https://api.heroku.com/apps/example/releases
    puts 'attempting post of slug'
    post_response = HTTParty.post('https://api.heroku.com/apps/shopify-nomic/releases',
                             headers: { "ContentType" => 'application/json',
                              'Authorization' => api_key,
                               'Accept' => 'application/vnd.heroku+json; version=3' },
                               body: {"slug" => blob_response['id']})
    puts 'post response'
    puts post_response
    puts 'finished post of slug'
    'and now we are done'
  end
end
