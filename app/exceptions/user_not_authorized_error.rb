class UserNotAuthorizedError < StandardError
  def message
    "User is not authorized to perform this action"
  end
end
