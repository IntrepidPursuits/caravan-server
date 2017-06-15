class InvalidTripError < StandardError
  attr_reader :trip

  def initialize(trip)
    @trip = trip
  end

  def message
    "Invalid trip data. " + @trip.errors.full_messages.to_sentence
  end
end
