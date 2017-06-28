class InvalidCarJoin < StandardError
  def message
    "Cannot join a car that doesn't exist or that belongs to a different trip"
  end
end
