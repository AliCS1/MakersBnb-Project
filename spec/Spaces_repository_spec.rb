require 'space'
require 'spaces_repository'

def reset_spaces_table
  seed_sql = File.read('spec/seeds/spaces_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersBnB_test' })
  connection.exec(seed_sql)
end

describe SpaceRepository do
    before(:each) do 
        reset_spaces_table
    end

    it 'adds a space to the database' do
        repo = SpaceRepository.new
    

        new_space = Space.new
        new_space.name = 'New'
        new_space.description = 'dhsgs'
        new_space.price = '10'
        new_space.user_id = '1'
        new_space.available_from = '2022-11-05'
        new_space.available_to = '2022-11-12'
        
        repo.create(new_space)

        spaces_total = repo.all

        expect(spaces_total.length).to eq 4
    end

    it 'find spaces betweeen given dates' do
        repo = SpaceRepository.new

        avaialble = repo.available_spaces('2021-01-01', '2024-02-01')
        expect(available.length).to eq 3
    end


end
