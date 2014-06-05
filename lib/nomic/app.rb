require 'sinatra'
require 'haml'


Class Nomic::App < Sinatra::Base

    use Rack::CommonLogger

    set :views, File.join(Nomic::ROOT_PATH, "views")
    set :public, File.join(Nomic::ROOT_PATH, "public")

    get '/'
        haml :index
    end
end
