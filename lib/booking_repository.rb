require_relative 'booking'

class BookingRepository
    def all
        bookings = []
        sql = 'SELECT * FROM bookings;'
        result_set = DatabaseConnection.exec_params(sql, [])

        result_set.each do |book|

            # Create a new model object
            # with the record data.
            new_booking = Space.new
            new_booking.id = book['id'].to_i
            new_booking.spaces_id = book['spaces_id']
            new_booking.users_id = book['users_id']
            new_booking.confirmed = book['confirmed']
            new_booking.booking_date = book['booking_date']
      
            bookings << new_booking
          end
      
          return bookings
    end

    
    
    def create(booking)
        #insert data into bookings table
        sql = "INSERT INTO bookings (spaces_id, users_id, confirmed, booking_date) VALUES ($1, $2, $3, $4);"
        result_set = DatabaseConnection.exec_params(sql, [booking.spaces_id, booking.users_id, booking.confirmed, booking.booking_date])

        return booking
    end

end