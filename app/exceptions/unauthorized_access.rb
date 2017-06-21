class UnauthorizedAccess < StandardError
  def message
    'Unauthorized Client ID'
  end
end
