class CarNotInTransit < StandardError
  def message
    "Cannot update car's location unless it has a status of 'In Transit'"
  end
end
