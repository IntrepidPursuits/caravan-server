module Helpers
  module Requests
    def body
      response.body
    end

    def parsed_body
      JSON.parse(body)
    end

    def accept_header(version = 1)
      "application/vnd.caravan-server.com; version=#{version}"
    end

    def accept_headers
      {
        "Accept": accept_header,
        "Content-Type": "application/json"
      }
    end

    def authorization_headers(user = nil)
      accept_headers.merge("Authorization": "Bearer #{authorization_header(user)}")
    end

    def authorization_header(user = nil)
      EncodeJwt.perform(user: user)
    end

    def invalid_authorization_headers
      accept_headers.merge("Authorization": "Bearer #{SecureRandom.hex(20)}")
    end
  end
end
