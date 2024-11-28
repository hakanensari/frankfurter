# frozen_string_literal: true

require_relative "../helper"
require "rack/test"
require "web/server"

describe Web::Server do
  include Rack::Test::Methods

  let(:app) { Web::Server.freeze }
  let(:headers) { last_response.headers }

  it "handles root" do
    get "/"
    _(last_response).must_be(:ok?)
    json = Oj.load(last_response.body)
    _(json["versions"]).must_include("v1")
    _(json["docs"]).must_equal("https://frankfurter.dev")
  end

  it "routes /v1 to V1 handler" do
    get "/v1/"
    _(last_response).must_be(:ok?)
  end

  it "allows cross-origin requests" do
    ["/v1/", "/v1/latest", "/v1/2012-11-20"].each do |path|
      header "Origin", "*"
      get path

      assert headers.key?("Access-Control-Allow-Methods")
    end
  end

  it "responds to preflight requests" do
    ["/v1/", "/v1/latest", "/v1/2012-11-20"].each do |path|
      header "Origin", "*"
      header "Access-Control-Request-Method", "GET"
      header "Access-Control-Request-Headers", "Content-Type"
      options path

      assert headers.key?("Access-Control-Allow-Methods")
    end
  end
end
