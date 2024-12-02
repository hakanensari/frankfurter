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

    opts[:root] = File.expand_path("..", __FILE__)
    plugin :static,
      {
        "/" => "root.json",
        "/v1/openapi.json" => "v1/openapi.json",
        "/robots.txt" => "robots.txt",
      },
      header_rules: [
        [:all, { "cache-control" => "public, max-age=900" }],
      ]
    plugin :json
    plugin :not_found do
      { message: "not found" }
    end

    route do |r|
      r.on("v1") do
        r.run(Versions::V1)
      end
    end
  end
end
