module Helpers
  module Requests
    def api_version
      1
    end

    def accept_header
      "application/vnd.caravan-server.com; version=#{api_version}"
    end

    def accept_headers
      { "Accept" => accept_header,
        "Content-Type" => "application/json"
      }
    end
  end
end
