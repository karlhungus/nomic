require 'sinatra'
require 'haml'
require 'nomic'
require 'json'
require 'byebug'
require 'httparty'
require 'octokit'

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
      {'mission' => 'pr review comment'}.to_s
    when 'issue_comment'
      #go to comments url
      #get all comments
      #count last occurence of :+1+:
      #decide if enough +1+'s exist
      #if so merge, deploy_tarball
      comments_url = @@data['issue']['comments_url']
      comment_body = @@data['comment']['body']
      commment_user = @@data['comment']['user']['login']
      comment_pr = @@data['issue']['pull_request']['url']
      run_rules(@@data)
      #merge(comment_pr) if comment_pr
      { "mission" => "success" }.to_s

    end
  end

  get '/' do
    @data = @@data

    @rule_output = Nomic::Rule.descendants.map do |rule_class|
      rule = rule_class.new(@@data)
      "#{rule.name}: #{rule.pass}"
    end
    haml :index
  end

  get '/deploy_tarball' do
    api_key = 'OjJlY2Q3NWJiLWVmYTQtNGMzMC1iMDM0LTFlMTY0NGNkNTVlNQo='
    response = deploy(api_key, 'karlhungus/nomic','shopify-nomic')
    "<pre>#{response.to_s}</pre>"
  end


  def deploy(api_key, repo_name, app_name)
    content = '{ "source_blob": {"url": ' + "\"https://github.com/#{repo_name}/archive/master.tar.gz\"" + ', "version": "1"}}'

    HTTParty.post("https://api.heroku.com/apps/#{app_name}/builds",
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => api_key,
        'Accept' => 'application/vnd.heroku+json; version=3'
      },
      body: content)
  end

  def run_rules(issue_comment)
    Nomic::Rule.decendants.all? { |rule_class| rule_class.new(issue_comment).pass }
  end

  def merge(pull_url)
    #PUT /repos/:owner/:repo/pulls/:number/merge
    result = HTTParty.put(pull_url + '/merge',
                         headers: {
     "Authorization" => "token OAUTH-TOKEN"})
    puts result
  end
end
