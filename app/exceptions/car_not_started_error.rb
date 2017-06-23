class CarNotStartedError < StandardError
  def message
    "Cannot update car's location if it has a status of 'Not Started'"
  end
end
