module Yelp
  class BusinessSearch < YelpApi

    DEFAULT_LIMIT = 5
    DEFAULT_OPEN_NOW = true
    LOCATION_NOT_FOUND_ERROR_CODE = 'LOCATION_NOT_FOUND'.freeze

    def initialize(parameters)
      super
      @parameters[:limit] ||= DEFAULT_LIMIT
      @parameters[:open_now] ||= DEFAULT_OPEN_NOW
    end

    def businesses
      if error_code == LOCATION_NOT_FOUND_ERROR_CODE
        Rails.logger.info "Yelp API returned location not found error for parameters: #{@parameters}"
        []
      else
        parsed_response_body['businesses'].map { |data| Yelp::Business.new(data) }
      end
    end

    private

    def api_path
      '/businesses/search'
    end

  end
end
