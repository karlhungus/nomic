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
    location_of_tgz = 'https://github.com/karlhungus/nomic/archive/7380385c1703a202d84d3d36589eae8b3b8560de.tar.gz'


    #request slug allocation

    puts 'Requesting slug allocation'
    @result = HTTParty.post('https://api.heroku.com/apps/shopify-nomic/slugs',
                            headers: { "ContentType" => 'application/json',
                              'Authorization' => '2ecd75bb-efa4-4c30-b034-1e1644cd55e5',
                               'Accept' => 'application/vnd.heroku+json; version=3' },
                            body:
                              { "process_types" => {"web" => "ruby-2.0.0/bin/ruby server.rb"}})
    puts 'results of requestion slug allocaiton'
    puts @result
    puts 'fetching blob'
    blob_response = JSON.parse(@result)['blob']
    puts 'blob response'
    puts blob_response

    #push slug to server
    #HTTParty.put('https://api.heroku.com/apps/shopify-nomic/releases',
    #             headers: {"Content-Type" => "application/json",
    #               "Accept" => "application/vnd.heroku+json; version=3",
    #'Authorization' => '2ecd75bb-efa4-4c30-b034-1e1644cd55e5',},
    #             body: {"slug" => blob_response})

    #release slug
    #curl -X POST \
    #-H "Accept: application/vnd.heroku+json; version=3" \
    #-H "Content-Type: application/json" \
    #-d '{"slug":"d969e0b3-9892-3113-7653-1aa1d1108bc3"}' \
    #-n https://api.heroku.com/apps/example/releases
    puts 'attempting post of slug'
    post_response = HTTParty.post('https://api.heroku.com/apps/shopify-nomic/releases',
                             headers: { "ContentType" => 'application/json',
                              'Authorization' => '2ecd75bb-efa4-4c30-b034-1e1644cd55e5',
                               'Accept' => 'application/vnd.heroku+json; version=3' },
                               body: {"slug" => File.join(Nomic::ROOT_PATH, location_of_tgz)})
    puts 'finished post of slug'
    'and now we are done'
  end
end
