class UserBooking
    attr_reader :booking_id, :spaces_id, users_id:, confirmed:, booking_date:  # :space_location

    def initialize(booking_id:, spaces_id:, users_id:, confirmed:, booking_date:) # add location?
        @booking_id = booking_id
        @spaces_id = spaces_id
        @users_id = users_id
        @confirmed = confirmed
        @booking_date
        # @space_location = space_location
    end

    result = DatabaseConnection.query(
        SELECT *
        FROM bookings_seeds
    )

    # result.map do |booking|
    #     UserBooking.new(

    #     )