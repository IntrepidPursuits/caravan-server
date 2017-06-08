require "rails_helper"

RSpec.describe Seat, type: :model do
  describe "associations" do
    it { should belong_to(:car) }
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:car) }
    it { should validate_presence_of(:user) }
    it do
      create(:seat)
      should validate_uniqueness_of(:user).scoped_to(:car_id)
    end

    it "cap the number of associated seats correctly" do
      car = create(:car, num_seats: 1)
      seats = car.seats
      expect(seats.empty?).to be true

      valid_seat = create(:seat, car: car)
      expect(seats.count).to be 1
      expect(seats).to include(valid_seat)

      invalid_seat = build(:seat, car: car)
      expect(invalid_seat.valid?).to be false
      expect(seats.count).to be 1
      expect(seats).to_not include(invalid_seat)
    end
  end
end
