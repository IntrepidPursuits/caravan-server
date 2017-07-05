class InvalidCarLeave < StandardError
  def message
    "Unable to leave car; it doesn't exist or user is not signed up for it."
  end
end
