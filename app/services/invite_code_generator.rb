require "securerandom"

class InviteCodeGenerator
  attr_reader :invite_code

  def initialize
    @invite_code = generate_code
  end

  private

  def generate_code
    code = InviteCode.new(code: SecureRandom.hex(10))
    if code.save
      return code
    else
      generate_code
    end
  end
end
