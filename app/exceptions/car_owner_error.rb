class CarOwnerError < StandardError
  def message
    "User already owns a car for this trip"
  end
end
