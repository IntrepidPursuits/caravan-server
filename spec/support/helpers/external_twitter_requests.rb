module ExternalTwitterRequests
  def stub_twitter_token_request
    stub_request(:get, "https://api.twitter.com/1.1/account/verify_credentials.json")
      .to_return(body: valid_twitter_token_request_body)
  end

  def valid_twitter_token_request_body
    load_fixture("twitter_info_response.json")
  end

  def stub_invalid_twitter_token_request
    stub_request(:get, "https://api.twitter.com/1.1/account/verify_credentials.json")
      .to_return(body: invalid_twitter_token_request_body)
  end

  def invalid_twitter_token_request_body
    load_fixture("twitter_invalid_token_response.json")
  end

  def stub_twitter_missing_id_request
    stub_request(:get, "https://api.twitter.com/1.1/account/verify_credentials.json")
    .to_return(body: twitter_missing_id_body)
  end

  def twitter_missing_id_body
    load_fixture("twitter_missing_id_response.json")
  end

  def stub_twitter_missing_name_request
    stub_request(:get, "https://api.twitter.com/1.1/account/verify_credentials.json")
      .to_return(body: twitter_missing_name_body)
  end

  def twitter_missing_name_body
    load_fixture("twitter_missing_name_response.json")
  end

  def stub_twitter_missing_image_request
    stub_request(:get, "https://api.twitter.com/1.1/account/verify_credentials.json")
      .to_return(body: twitter_missing_image_body)
  end

  def twitter_missing_image_body
    load_fixture("twitter_missing_image_response.json")
  end

  def twitter_token
    SecureRandom.hex(20)
  end

  def twitter_token_secret
    SecureRandom.hex(20)
  end
end
