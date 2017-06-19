class InvalidInviteCodeError < StandardError
  def message
    "Invalid invite code. Please verify that you have the correct code."
  end
end
