class InviteCodeValidator
  def self.perform(trip, input_invite_code)
    new(trip, input_invite_code).perform
  end

  def initialize(trip, input_invite_code)
    @trip = trip
    @source_invite_code = @trip.invite_code.code
    @input_invite_code = input_invite_code
  end

  def perform
    if @source_invite_code == @input_invite_code
      return true
    else
      raise InvalidInviteCodeError.new
    end
  end
end
