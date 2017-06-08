class Seat < ApplicationRecord
  belongs_to :car
  belongs_to :user

  validates :car, presence: true
  validates :user, presence: true, uniqueness: { scope: :car_id }

  validate :seats_within_limit, on: :create

  private

  def seats_within_limit
    if @car = self.car
      full_car?
    end
  end

  def full_car?
    filled = @car.seats_filled
    max_seats = @car.num_seats
    return if filled == 0
    errors[:base] << "This car is already full!" if filled = max_seats
  end
end
