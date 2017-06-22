class MissingInviteCodeError < StandardError
  def message
    "Invite code is missing."
  end
end
