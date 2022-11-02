require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/user_repository'

DatabaseConnection.connect('makersBnB_test')
enable :sessions

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/user_repository'
  end

  get '/' do

    return erb(:index)
  end
  #test to see all the users displayed
  get '/users' do
    repo = UserRepository.new
    users = repo.all

    response = users.map do |user|
      user.email
    end.join(', ')

    return response
  end

  get '/signup' do
    return erb(:signup)
  end

  post '/signup' do
    if(invalid_user_signup == true)
      status 400
      return ''
    end
    @display = ''
  
    repo = UserRepository.new
    new_user = User.new
    new_user.email = params[:email]
    new_user.password_1 = params[:password_1]
    repo.create(new_user)

    session[:user_id] = new_user.id
    return redirect('/users')
    @display = 'Your account has been created!'
  end



  def invalid_user_signup
    repo = UserRepository.new
    user_email = params[:email]
    #checking if any input fields are empty
    if(params[:password_1] == '' || params[:password_2] == '' || params[:email] == '')
      return true
    #checking if the passwords match
    elsif(params[:password_1] != params[:password_2])
      return true
      #checking the length is over 8 characters
    elsif(params[:password_1].length < 8)
      return true
      #checking there are capital letters
    elsif(valid_password_case == false)
      return true
      #checking there are special characters
    elsif(valid_password_symbols == false)
      return true
      #checking if the email is in use
    #elsif(email_in_use == true)
    #  return true
    else 
      return false
    end

  end

  def valid_password_symbols
    special = "?<>',!£€?[]}{=-)(*&^%$#`~{}"
    array = params[:password_1].split(//)

    array.each do |character|
      if(special.include?(character))
        return true
      end
    end
    return false
  end


  def valid_password_case
    array = params[:password_1].split(//)

    array.each do |character|
      if(character == character.upcase)
        return true
      end
    end
    return false
  end

  def email_in_use
    repo = UserRepository.new
    valid = repo.find_email(params[:email])

    if(valid == params[:email])
      return false
    else
      return true
    end
  end

end