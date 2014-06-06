require 'sinatra'
require 'haml'
require 'nomic'
require 'json'
require 'byebug'
require 'httparty'
require 'github_helper'

class Nomic::App < Sinatra::Base
  include GithubHelper
  use Rack::CommonLogger
  set :views, File.join(Nomic::ROOT_PATH, "views")

  @@data = {request: "no request"}
  post '/payload' do
    @@data = JSON.parse request.body.read

    case request.env['HTTP_X_GITHUB_EVENT']
    when 'issue_comment'
      comment_repository = @@data['repository']['full_name']
      pr_number = @@data['issue']['number']

      run_results = run_rules(@@data)
      outcome = run_results.all? {|key, value| value == true }
      comment(comment_repository, pr_number, outcome, run_results)
      if outcome
        result = merge(comment_repository, pr_number) if outcome
        deploy(Nomic.heroku_token, comment_repostory, 'shopify-nomic') if result
      end
      { "outcome:" => run_results.to_s }.to_s
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
    response = deploy(Nomic.heroku_token, 'karlhungus/nomic','shopify-nomic')
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
    Nomic::Rule.descendants.map do |rule_class|
      rule = rule_class.new(issue_comment)
      {rule.name => rule.pass}
    end
  end

  def comment(repo_name, pr_number, outcome, run_results)
    comment = outcome ? 'Rules Passed, merging, deploying' : 'Rules Failed'
    comment += ": #{run_results}"
    github_client.add_comment(repo_name, pr_number, comment)
  end

  def merge(repo_name, pr_number)
    github_client.merge_pull_request(repo_name, pr_number)
  end
end
