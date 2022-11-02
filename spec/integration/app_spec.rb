require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context 'GET /signup' do
    it 'describes the signup page' do
        response = get('/signup')
        
        expect(response.status).to eq 200

        expect(response.body).to include('<form method = "POST" action = "/signup" style="margin: auto; width: 35%; text-align: center; border: 1 black; background-color: gray;">')
        expect(response.body).to include('<input type = "text" name = "email" />')
        expect(response.body).to include('<input type = "password" name = "password_1" />')
        expect(response.body).to include('<input type = "password" name = "password_2" />')
    end
  end

  context 'POST /signup' do
    it 'catches an empty password box and returns 400' do
        response = post('/signup',
      email: 'Ali@gmail.com',
      password_1: 'hst',
      password_2: '')

      expect(response.status).to eq 400
    end

    it 'catches that the two passwords arent the same and returns 400' do
      response = post('/signup',
      email: 'Ali@gmail.com',
      password_1: '23456',
      password_2: '12345')

      expect(response.status).to eq 400
    end

    it 'catches that the two passwords have less than 8 characters and returns 400' do
      response = post('/signup',
      email: 'Ali@gmail.com',
      password_1: '12345',
      password_2: '12345')

      expect(response.status).to eq 400
    end

    #it 'catches that the email being used is already in the database as a user' do
    #  response = post('/signup',
    #  email: '123@gmail.com',
    #  password_1: '123AB£C4567A',
    #  password_2: '123AB£C4567A')

    #  expect(response.status).to eq 400
    #end

    
  end

  context 'POST /login' do
    it 'checks if user logs in' do
      response = post('/login',email:'ABC@gmail.com', password:'MyPassword123')


      expect(response.body).to eq("SUCCESSFULLY LOGGED IN ABC@gmail.com")

    end
    it 'given incorrect password' do
      response = post('/login',email:'ABC@gmail.com', password:'MyPassword123')


      expect(response.body).to eq("BAD PASSWORD")

    end



  end

end
