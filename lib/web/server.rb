# frozen_string_literal: true

require 'oj'
require 'rack/contrib/jsonp'
require 'rack/cors'
require 'roda'

require 'currency_names'
require 'query'
require 'quote'

module Web
  class Server < Roda
    use Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: %i[get options]
      end
    end
    use Rack::JSONP

    plugin :caching

    plugin :error_handler do |_error|
      request.halt [422, {}, nil]
    end

    plugin :indifferent_params

    plugin :json, content_type: 'application/json; charset=utf-8',
                  serializer: ->(o) { Oj.dump(o, mode: :compat) }

    plugin :params_capturing

    route do |r|
      r.root do
        { docs: 'https://www.frankfurter.app/docs' }
      end

      r.is(/latest|current/) do
        r.params['date'] = Date.today.to_s
        quote = quote_end_of_day(r)
        r.etag quote.cache_key

        quote.formatted
      end

      r.is(/(\d{4}-\d{2}-\d{2})(\.\.)?/) do
        r.params['date'] = r.params['captures'].first
        quote = quote_end_of_day(r)
        r.etag quote.cache_key

        quote.formatted
      end

      r.is(/(\d{4}-\d{2}-\d{2})\.\.(\d{4}-\d{2}-\d{2})/) do
        r.params['start_date'] = r.params['captures'].first
        r.params['end_date'] = r.params['captures'][1] || Date.today.to_s
        quote = quote_interval(r)
        r.etag quote.cache_key

        quote.formatted
      end

      r.is 'currencies' do
        currency_names = CurrencyNames.new
        r.etag currency_names.cache_key

        currency_names.formatted
      end
    end

    private

    def quote_end_of_day(request)
      query = Query.build(request.params)
      quote = Quote::EndOfDay.new(**query)
      quote.perform
      request.halt [404, {}, nil] if quote.not_found?

      quote
    end

    def quote_interval(request)
      query = Query.build(request.params)
      quote = Quote::Interval.new(**query)
      quote.perform
      request.halt [404, {}, nil] if quote.not_found?

      quote
    end
  end
end
