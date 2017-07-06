module ExternalRequests
  def stub_google_token_request
    stub_request(:get, /.*googleapis.com\/oauth2\/v3\/tokeninfo.*/)
      .to_return(body: valid_token_request_body, headers: json_content)
  end

  def valid_token_request_body
    response = JSON.parse load_fixture("google_info_response.json")
    response["aud"] = ENV["GOOGLE_CLIENT_ID"]
    response.to_json
  end

  def json_content
    { content_type: "application/json" }
  end

  def stub_sign_in_existing(google_uid)
    response = google_user_info
    response["sub"] = google_uid
    response.to_json
  end

  def google_user_info
    load_fixture("google_info_response.json")
  end

  def stub_expired_token_request
    stub_request(:get, /.*googleapis.com\/oauth2\/v3\/tokeninfo.*/)
      .to_return(body: invalid_token_body, headers: json_content)
  end

  def stub_non_google_token_request
    stub_request(:get, /.*googleapis.com\/oauth2\/v3\/tokeninfo.*/)
    .to_return(body: invalid_token_body, headers: json_content)
  end

  def invalid_token_body
    response = JSON.parse load_fixture("invalid_token_response.json")
    response.to_json
  end

  def stub_invalid_client_id_request
    stub_request(:get, /.*googleapis.com\/oauth2\/v3\/tokeninfo.*/)
      .to_return(body: invalid_client_id_body, headers: json_content)
  end

  def invalid_client_id_body
    response = JSON.parse load_fixture("not_our_client_id_response.json")
    response.to_json
  end

  def stub_missing_email_request
    stub_request(:get, /.*googleapis.com\/oauth2\/v3\/tokeninfo.*/)
    .to_return(body: google_info_missing_email_body, headers: json_content)
  end

  def google_info_missing_email_body
    response = JSON.parse load_fixture("google_info_missing_email_response.json")
    response["aud"] = ENV["GOOGLE_CLIENT_ID"]
    response.to_json
  end

  def stub_missing_uid_request
    stub_request(:get, /.*googleapis.com\/oauth2\/v3\/tokeninfo.*/)
    .to_return(body: google_info_missing_uid_body, headers: json_content)
  end

  def google_info_missing_uid_body
    response = JSON.parse load_fixture("google_info_missing_uid_response.json")
    response["aud"] = ENV["GOOGLE_CLIENT_ID"]
    response.to_json
  end


  def stub_missing_name_request
    stub_request(:get, /.*googleapis.com\/oauth2\/v3\/tokeninfo.*/)
    .to_return(body: google_info_missing_name_body, headers: json_content)
  end

  def google_info_missing_name_body
    response = JSON.parse load_fixture("google_info_missing_name_response.json")
    response["aud"] = ENV["GOOGLE_CLIENT_ID"]
    response.to_json
  end
end
