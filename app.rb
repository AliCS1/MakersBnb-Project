require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/user_repository'
require_relative 'lib/spaces_repository'







class Application < Sinatra::Base
  configure :development do
    enable :sessions
    register Sinatra::Reloader
    also_reload 'lib/user_repository'
  end

  get '/' do
    repo = SpaceRepository.new
    spaces = repo.available_spaces('2021-01-01', '2024-02-01')
     spaces

    @name = spaces.map do |property| 
      property.name
    end

    p @name

    @id = spaces.map do |property| 
      property.id
    end

    @description = spaces.map do |property| 
      property.description
    end

    # session[:available_listings] = spaces

    # @listings = session[:available_listings]
    return erb(:index)
  end

  post '/' do
    repo = SpaceRepository.new
    spaces = repo.available_spaces(params[:date_from], params[:date_to])

    session[:available_listings] = spaces
  end

  get '/new_space' do
    return erb(:new_space)
  end

  post '/new_space' do


    space = Space.new
    
    session[:user_id] = 2

    if defined?(session[:user_id]) == nil 
      space.user_id = session[:user_id]
    else
      space.user_id = 1
    end

    space.name = params[:fname]
    space.description = params[:description]
    space.price = params[:price_per_night]
    space.available_from = params[:date_from]
    space.available_to = params[:date_to]

    repo = SpaceRepository.new
    repo.create(space)

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
      status 400
      return erb(:signup)
    end
    @display = ''
  
    repo = UserRepository.new
    new_user = User.new
    new_user.email = params[:email]
    new_user.password_1 = params[:password_1]
    repo.create(new_user)
    
    session[:user_id] = new_user.id
    session[:email] = new_user.email
    return redirect('/users')
    @display = 'Your account has been created!'
  end

  get '/login' do

    return erb(:login_page)

  end

  post '/login' do
    email = params[:email]
    password = params[:password]

    if valid_login_attempt(email,password)
      user = find_email(email)
      session[:user_id] = user.id
      session[:email] = user.email
      return "SUCCESSFULLY LOGGED IN "+session[:email]
    else
    return 'BAD PASSWORD OR EMAIL'

    end

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

  def email_in_use(email)
    repo = UserRepository.new
    valid = repo.find_email(email)

    if(valid.email == email)
      return false
    else
      return true
    end
  end

  def valid_email_entered(email)
    #email needs an '@' and a dot in order to be valid
    if email.contains("@") == false
      return false
    end
  end

  def valid_login_attempt(email,password)
    repo = UserRepository.new
    return repo.check_if_exists(email,password)
    
  end

  def find_email(email)
    repo = UserRepository.new
    return repo.find_email(email)


  end


end