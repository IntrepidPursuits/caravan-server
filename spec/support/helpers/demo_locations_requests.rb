module DemoLocationsRequests  
  def stub_reset_locations
    stub_request(:post, /.*caravan-server-staging.herokuapp.com\/api\/v1\/cars.*\/locations/)
      .to_return(body: reset_locations_body, status: 201)
  end

  def reset_locations_body
    response = JSON.parse(load_fixture("reset_demo_locations_response.json"))
    response.to_json
  end

  def stub_post_locations
    stub_request(:post, /.*caravan-server-staging.herokuapp.com\/api\/v1\/cars.*\/locations/)
    .to_return(body: perform_locations_body, status: 201)
  end

  def perform_locations_body
    response = JSON.parse(load_fixture("perform_demo_locations_response.json"))
    response.to_json
  end
end
