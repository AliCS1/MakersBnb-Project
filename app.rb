require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/user_repository'

#DatabaseConnection.connect('makersBnB_test')
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
    @errors = []
    @emails = ""
    return erb(:signup)
  end

  post '/signup' do
    @errors = invalid_user_signup
    @emails = params[:email]
    if(@errors.length > 0)
      status 200
      return erb(:signup)
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

  get '/login' do

    return erb(:login_page)

  end

  post '/login' do
    @email = params[:email]
    @password = params[:password]

    return 'You submitted ' + email + " with password " + password



  end



  def invalid_user_signup
    errors = []
    repo = UserRepository.new
    user_email = params[:email]
    mistake = false
    #checking if any input fields are empty
    if (params[:password_1] == '' || params[:password_2] == '' || params[:email] == '')
      errors.push("One of your fields is empty!")
      mistake = true
    end
    #checking if the passwords match
    if(params[:password_1] != params[:password_2])
      errors.push("Your passwords dont match!")
      mistake = true
    end
      #checking the length is over 8 characters
    if(params[:password_1].length < 8)
      errors.push("Your password is less than 8 characters")
      mistake = true
    end
      #checking there are capital letters
    if(valid_password_case == false)
      errors.push("You didn't add a capital letter")
      mistake = true

    end
      #checking there are special characters
    if(valid_password_symbols == false)
      errors.push("You didn't add a special character")
      mistake = true

    end
      #checking if the email is in use
    #elsif(email_in_use == true)
    #  return true
    return errors

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