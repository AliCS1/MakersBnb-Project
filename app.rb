require 'sinatra/base'
require 'sinatra/reloader'

require_relative 'lib/database_connection'

DatabaseConnection.connect('')
class Application < Sinatra::Base
  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    #set :public_founder, File.expand_path('../public', __FILE__)
    register Sinatra::Reloader
  end

  get '/' do

    return erb(:index)
  end

  get '/sessions/new' do

    return erb(:login_page)

  end

  post '/sessions/new' do
    @email = params[:email]
    @password = params[:password]

    return 'You submitted ' + email + " with password " + password



  end
end