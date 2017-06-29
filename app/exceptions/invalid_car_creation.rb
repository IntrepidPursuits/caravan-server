class InvalidCarCreation < StandardError
  def message
    "You must provide a valid trip_id in order to create a car"
  end
end
