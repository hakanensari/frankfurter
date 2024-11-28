# frozen_string_literal: true

require "rack/cors"
require "roda"

require "web/versions/v1"

module Web
  class Server < Roda
    use Rack::Cors do
      allow do
        origins "*"
        resource "*", headers: :any, methods: [:get, :options]
      end
    end

    plugin :json

    route do |r|
      r.root do
        {
          name: "Frankfurter",
          description: "Exchange Rates API",
          versions: {
            "v1" => "/v1",
          },
          docs: "https://frankfurter.dev",
        }
      end

      r.on("v1") do
        r.run(Versions::V1)
      end
    end
  end
end
