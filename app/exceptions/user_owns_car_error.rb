class UserOwnsCarError < StandardError
  def message
    "Could not join car: user owns another car for this trip"
  end
end
