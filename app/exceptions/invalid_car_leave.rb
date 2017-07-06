class InvalidCarLeave < StandardError
  def message
    "Unable to leave car; it doesn't exist or user is not signed up properly."
  end
end
