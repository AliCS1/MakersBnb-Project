require_relative 'user'

class UserRepository
    def all
        users = []
        sql = 'SELECT * FROM users;'
        result_set = DatabaseConnection.exec_params(sql, [])

        result_set.each do |user|

            # Create a new model object
            # with the record data.
            new_user = User.new
            new_user.id = user['id'].to_i
            new_user.email = user['email']
            new_user.password_1 = user['password_1']
      
            users << new_user
          end
      
          return users

    end

    def create(user)
        sql = "INSERT INTO users (email, password_1) VALUES ($1, $2);"
    result_set = DatabaseConnection.exec_params(sql, [user.email, user.password_1])

    return user
    end

    def find(id)
    sql = 'SELECT id, email, password_1 FROM users WHERE id = $1;'
    result_set = DatabaseConnection.exec_params(sql, [id])

    user = User.new
    user.id = result_set[0]['id'].to_i
    user.email = result_set[0]['email']
    user.password_1 = result_set[0]['password_1']

    return user
    end

    def find_email(email)
    sql = 'SELECT id, email, password_1 FROM users WHERE email = $1;'
    result_set = DatabaseConnection.exec_params(sql, [email])

    user = User.new
    user.id = result_set[0]['id'].to_i
    user.email = result_set[0]['email']
    user.password_1 = result_set[0]['password_1']

    return user
end

    
end