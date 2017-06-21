module Helpers
  module Requests
    def body
      response.body
    end

    def parsed_body
      JSON.parse body
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
  end
end
