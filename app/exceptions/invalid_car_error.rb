class InvalidCarError < StandardError
  attr_reader :car

  def initialize(car)
    @car = car
  end

  def message
    "Invalid car data. " + @car.errors.full_messages.to_sentence
  end
end
