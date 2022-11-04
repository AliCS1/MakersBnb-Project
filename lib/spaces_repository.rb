require_relative 'space'

class SpaceRepository
    def all
        spaces = []
        sql = 'SELECT * FROM spaces;'
        result_set = DatabaseConnection.exec_params(sql, [])

        result_set.each do |space|

            # Create a new model object
            # with the record data.
            new_space = Space.new
            new_space.id = space['id'].to_i
            new_space.name = space['name']
            new_space.description = space['description']
            new_space.price = space['price']
            new_space.user_id = space['user_id']
            new_space.available_from = space['available_from']
            new_space.available_to = space['available_to']
      
            spaces << new_space
          end
      
          return spaces
    end

    
    
    def create(space)
        sql = "INSERT INTO spaces (name, description, price, user_id, available_from, available_to) VALUES ($1, $2, $3, $4, $5, $6);"
        result_set = DatabaseConnection.exec_params(sql, [space.name, space.description, space.price, space.user_id, space.available_from, space.available_to])

        return space
    end

    def find(id)
        sql = 'SELECT id, name, description, price, user_id, available_from, available_to FROM spaces WHERE id = $1;'
        result_set = DatabaseConnection.exec_params(sql, [id])


        new_space = Space.new
        new_space.id = result_set[0]['id'].to_i
        new_space.name = result_set[0]['name']
        new_space.description = result_set[0]['description']
        new_space.price = result_set[0]['price']
        new_space.user_id = result_set[0]['user_id']
        new_space.available_from = result_set[0]['available_from']
        new_space.available_to = result_set[0]['available_to']

        return new_space
    end

    def available_spaces(date1, date2)
        #checks which spaces are available between two dates
        spaces = []
        sql = 'SELECT id, name, description, price, user_id, available_from, available_to FROM spaces WHERE available_to < $2 AND available_from >= $1;'
        result_set = DatabaseConnection.exec_params(sql, [date1, date2])

        result_set.each do |space|

            # Create a new model object
            # with the record data.
            new_space = Space.new
            new_space.id = space['id'].to_i
            new_space.name = space['name']
            new_space.description = space['description']
            new_space.price = space['price']
            new_space.user_id = space['user_id']
            new_space.available_from = space['available_from']
            new_space.available_to = space['available_to']
      
            spaces << new_space
          end
      
          return spaces
    end
end