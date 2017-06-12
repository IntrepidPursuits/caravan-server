require "securerandom"

class InviteCodeGenerator
  attr_reader :invite_code

  def initialize
    @invite_code = generate_code
  end

  private

  def generate_code
    code = SecureRandom.hex(10)
    if !Trip.where(invite_code: code).empty?
      code = generate_code
    end
    code
  end
end
