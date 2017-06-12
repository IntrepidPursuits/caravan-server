class InviteCodeGenerator
  attr_reader :invite_code

  def initialize(length = 10)
    @invite_code = generate_code(length)
  end

  private

  def generate_code(length)
    chars = "abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ0123456789"
    code = ""
    length.times do
      code += chars[rand(chars.size)]
    end
    if !Trip.where(invite_code: code).empty?
      code = generate_code(length)
    end
    code
  end
end
