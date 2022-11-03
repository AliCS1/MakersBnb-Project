class UserBooking
    attr_reader :id, :space_id, user_id:, confirmed:, booking_start:, booking_end:  # :space_location

    def initialize(id:, space_id:, user_id:, confirmed:, booking_start:, booking_end:) # add location?
        @id = id
        @space_id = spaces_id
        @user_id = users_id
        @confirmed = confirmed
        @booking_start = booking_start
        @booking_end = booking_end
        # @space_location = space_location
    endß

    result = DatabaseConnection.query(
        SELECT *
        FROM bookings_seeds
    )

    # result.map do |booking|
    #     UserBooking.new(

    #     )