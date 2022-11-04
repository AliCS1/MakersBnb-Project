require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/user_repository'
require_relative 'lib/spaces_repository'
require_relative 'lib/booking_repository'



#<% @description.each do |space| %>
#  <a href="/spaces/<%=@id[@description.find_index(space)]%>>
#  <h3>
#  <%=@name[@description.find_index(space)]%>
#  </h3>
#  <h4>
#  <%=space%>
#  </h4>
#  </a>
#  <%end%>



class Application < Sinatra::Base
  configure :development do
    enable :sessions
    register Sinatra::Reloader
    also_reload 'lib/user_repository'
  end

  get '/' do
    repo = SpaceRepository.new
    #checks if the session starting date contains a value - if not the two date sessions are assigned a 
    #value so the search below can take place
    if session[:starting_date] == nil
      session[:starting_date] = '2022-01-01'
      session[:ending_date] = '2023-01-01'
    end
    #The search takes place using the two sessions as parameters
    spaces = repo.available_spaces(session[:starting_date], session[:ending_date])
    #to display the user id to know if the user is logged in
    @current_email = session[:email]
    #creating an empty array that will later contain all of the spaces
    @list_of_spaces = []

    #going into the searched query (line 39) and putting the contents of the search into the list
    #list of spaces is now an array, with each index containing one property object
    spaces.each { |space|
      current_space = Space.new

      current_space.id = space.id
      current_space.name = space.name
      current_space.description = space.description
      current_space.price = space.price

      @list_of_spaces << current_space


    }

    if (session[:user_id]) == nil
      #if the user isnt logged in, signout is false as we want to login
      @signout = false
    else 
      @signout = true
    end

    #@name = spaces.map do |property| 
    #  property.name
    #end

    #@id = spaces.map do |property| 
    #  property.id
    #end

    #@description = spaces.map do |property| 
    #  property.description
    #end

    # session[:available_listings] = spaces

    # @listings = session[:available_listings]
    return erb(:index)
  end

  post '/' do
    #here we are changing the session dates to equal ones that the user has selected
    
    session[:starting_date] = params[:date_from]
    session[:endng_date] = params[:date_to]
    #refreshing the page

    return redirect("/")


  end

  get '/spaces/:id' do
  repo = SpaceRepository.new
  #using the find method to find the space which is equal to the id the user selected
  space = repo.find(params[:id])
  #saving the id as a session variable
  session[:space_id] = params[:id]

  #uploading the name, description and price as variables that the erb file can read and display

  @name = space.name
  @description = space.description
  @price = space.price

  @current_user = session[:email]

  return erb(:listing)
end

post '/spaces/:id' do
  repo = BookingRepository.new
  booking = Booking.new
  #ensuring the user is logged in, if not redirecting them to the login page
  if(session[:user_id] == nil)
    return redirect('/login')
  end

  #making a booking by filling it with attributes
  booking.users_id = session[:user_id]
  booking.spaces_id = session[:space_id]
  booking.confirmed = false
  booking.booking_date = params[:date]
  #using the create method to insert data into the booking table
  repo.create(booking)
  #directing the user to the confirmation page
  return redirect('/booking_confirm')
end

get '/booking_confirm' do
  repo = SpaceRepository.new
  space = repo.find(session[:space_id])
  #displaying the name of the space they have requested to book
  @name = space.name
  
  return erb(:confirmation)
end

post '/booking_confirm' do
  #when they press this button to confirm they have acknowledged their booking is confirmed
  #they get redirected to the home page
  return redirect('/')
end


  get '/new_space' do
    return erb(:new_space)
  end

  post '/new_space' do


    space = Space.new
    
    session[:user_id] = 2
    #checking if a user is logged in,
    #if not assigning them an id of 1

    if defined?(session[:user_id]) == nil 
      space.user_id = session[:user_id]
    else
      space.user_id = 1
    end

    #filling space with attributes from the html form
    space.name = params[:fname]
    space.description = params[:description]
    space.price = params[:price_per_night]
    space.available_from = params[:date_from]
    space.available_to = params[:date_to]
    #using the create method to insert data into the spaces table
    repo = SpaceRepository.new
    repo.create(space)

  end


  #test to see all the users displayed
  get '/users' do
    #this is not used - this was purely to see all of the users
    repo = UserRepository.new
    users = repo.all

    response = users.map do |user|
      user.email
    end.join(', ')

    return response
  end

  get '/signup' do
    #errors is an array filled with any errors the user has when signing up
    @errors = []
    @emails = ""
    return erb(:signup)
  end

  post '/signup' do
    #populate errors with the invalid user signup method
    @errors = invalid_user_signup
    @emails = params[:email]
    #if there are errors then the code wont work
    if(@errors.length > 0)
      status 400
      return erb(:signup)
    end
    
    #filling up a user with attributes
    repo = UserRepository.new
    new_user = User.new
    new_user.email = params[:email]
    new_user.password_1 = params[:password_1]
    #using the create method to insert data into the users database
    repo.create(new_user)
    
    #storing the user id and email as sessions
    session[:user_id] = new_user.id
    session[:email] = new_user.email
    return redirect('/')
  end

  get '/login' do

    return erb(:login_page)

  end

  post '/login' do
    email = params[:email]
    password = params[:password]
    # if the login was successful
    if valid_login_attempt(email,password)
      user = find_email(email)
      session[:user_id] = user.id
      session[:email] = user.email
      #return "SUCCESSFULLY LOGGED IN "+session[:email]
      return redirect('/')
    else
    return 'BAD PASSWORD OR EMAIL'

    end

  end

  get '/signout' do
    #checking if the user is signed in before
    if(session[:user_id]) == nil
      @email = 'Please login before attempting to signout'
    else
      @id = session[:user_id]
      @email = session[:email]
    end
    
    return erb(:signout)
  end

  post '/signout' do
    #make the session id and email equal nothing
    session[:user_id] = nil
    session[:user_email] = nil
    #return the user to the homepage

    return redirect('/')
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
    #checks if the password contains at least one symbol
    special = "?<>',!£€?[]}{=-)(*&^%$#`~{}"
    array = params[:password_1].split(//)

    array.each do |character|
      #instantly when a symbol is found then true is returned
      if(special.include?(character))
        return true
      end
    end
    return false
  end


  def valid_password_case
    array = params[:password_1].split(//)
    #instantly when a capital letter is found, true is returned
    array.each do |character|
      if(character == character.upcase)
        return true
      end
    end
    return false
  end

  def email_in_use(email) 
    #checks if the email entered already exists within the database
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
    #checks if the password and email exist in the users table
    repo = UserRepository.new
    return repo.check_if_exists(email,password)
    
  end

  def find_email(email)
    repo = UserRepository.new
    return repo.find_email(email)


  end


end