class UnauthorizedAccess < StandardError
  def message
    "Invalid token: Check that you have the correct client ID, all required permissions, and that your token has not expired."
  end
end
