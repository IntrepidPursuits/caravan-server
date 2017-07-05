class LeaveACar
  def initialize(car, signup, user)
    @car = car
    @signup = signup
    @user = user
  end

  def self.perform(car, signup, user)
    new(car, signup, user).perform
  end

  def perform
    return destroy_car if @user == @car.owner
    @signup.update_attributes!(car: nil)
  end

  def destroy_car
    signups = Signup.where(car: @car)
    signups.each do |signup|
      signup.update_attributes!(car: nil)
    end
    @car.destroy
  end
end
