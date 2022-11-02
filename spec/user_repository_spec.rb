require 'user'
require 'user_repository'

def reset_users_table
  seed_sql = File.read('spec/seeds/user_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersBnB_test' })
  connection.exec(seed_sql)
end

describe UserRepository do
    before(:each) do 
        reset_users_table
    end

    it 'adds a user to the database' do
        repo = UserRepository.new
        user = User.new

        user.email = 'tom@gmail.com'
        user.password_1 = 'password1'
        repo.create(user)

        users_total = repo.all

        expect(users_total.length).to eq 3
    end

    it 'adds two users to the database' do
        repo = UserRepository.new
        user_1 = User.new

        user_1.email = 'tom@gmail.com'
        user_1.password_1 = 'password1'
        repo.create(user_1)

        user_2 = User.new

        user_2.email = 'ali@gmail.com'
        user_2.password_1 = 'password2'
        repo.create(user_2)

        users_total = repo.all

        expect(users_total.length).to eq 4
    end

    it 'checks the find method works' do
        repo = UserRepository.new

        user = repo.find(1)

        expect(user.password_1).to eq ('MyPassword123')
        expect(user.email).to eq ('ABC@gmail.com')
    end

    it 'checks the find email method works' do
        repo = UserRepository.new
        user = repo.find_email('ABC@gmail.com')

        expect(user.email).to eq ('ABC@gmail.com')
        expect(user.id).to eq 1
    end


end
