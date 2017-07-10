class MissingSignup < StandardError
  def message
    "You are not signed up for this trip"
  end
end
