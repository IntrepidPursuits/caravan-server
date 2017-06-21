class InviteCodeGenerator
  attr_reader :invite_code

  def self.perform
    new.perform
  end

  def perform
    code = InviteCode.new(code: SecureRandom.hex(3))
    if code.save
      return code
    else
      perform
    end
  end
end
