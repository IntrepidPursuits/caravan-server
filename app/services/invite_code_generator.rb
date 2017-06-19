class InviteCodeGenerator
  def self.perform
    new.perform
  end

  def perform
    code = InviteCode.new(code: '%06d' % SecureRandom.random_number(999999))
    if code.save
      return code
    else
      perform
    end
  end
end
