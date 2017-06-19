module ExternalRequests
  def stub_google_token_request
    stub_request(:get, /.*googleapis.com\/oauth2\/v3\/tokeninfo.*/)
      .to_return(body: valid_token_request_body, headers: json_content)
  end

  def valid_token_request_body
    response = JSON.parse load_fixture("unverified_token_object.json")
    response["aud"] = ENV["GOOGLE_CLIENT_ID"]
    response.to_json
  end

  def json_content
    { content_type: "application/json" }
  end

  def stub_google_profile_request
    stub_request(:get, /.*googleapis.com\/plus\/v1\/people\/.*/)
      .to_return(status: :ok, body: google_user_info, headers: json_content)
  end

  def stub_sign_in_existing(google_uid)
    response = google_user_info
    response["sub"] = google_uid
    response.to_json
  end

  def google_user_info
    load_fixture("google_info_response.json")
  end

  def stub_empty_request
    stub_request(:get, /.*googleapis.com\/plus\/v1\/people\/.*/)
  end

  def stub_bad_token_request
    stub_request(:get, /.*googleapis.com\/oauth2\/v3\/tokeninfo.*/)
      .to_return(body: invalid_token_request_body, headers: json_content)
  end

  def invalid_token_request_body
    response = JSON.parse load_fixture("bad_token_request.json")
    response.to_json
  end
end
