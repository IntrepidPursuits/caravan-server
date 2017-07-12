class UnauthorizedTwitterAccess < StandardError
  def message
    "Invalid token: Check that you have the correct token and token secret."
  end
end
