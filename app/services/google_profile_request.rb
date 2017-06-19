class GoogleProfileRequest
  attr_reader :google_uid

  def initialize(google_uid)
    @google_uid = google_uid
  end

  def self.perform(google_uid)
    new(google_uid).perform
  end

  def perform
    raise InvalidGoogleUser if user_response.body.nil?
    user_response
  end

  def user_response
    url = "https://www.googleapis.com/plus/v1/people/#{google_uid}?key=#{GOOGLE_API_KEY}"
    @user_response ||= HTTParty.get(url)
  end

  class InvalidGoogleUser < StandardError; end
end
