class MissingSignup < StandardError
  def message
    "You must be signed up for a trip in order to create a car in that trip"
  end
end
