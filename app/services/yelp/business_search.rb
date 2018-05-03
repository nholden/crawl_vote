module Yelp
  class BusinessSearch < YelpApi

    DEFAULT_LIMIT = 5
    DEFAULT_OPEN_NOW = true

    def initialize(parameters)
      super
      @parameters[:limit] ||= DEFAULT_LIMIT
      @parameters[:open_now] ||= DEFAULT_OPEN_NOW
    end

    def businesses
      parsed_response_body['businesses'].map { |data| Yelp::Business.new(data) }
    end

    private

    def api_path
      '/businesses/search'
    end

  end
end
