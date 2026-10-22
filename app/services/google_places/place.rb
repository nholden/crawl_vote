module GooglePlaces
  class Place

    PRICE_LEVELS = {
      'PRICE_LEVEL_INEXPENSIVE' => '$',
      'PRICE_LEVEL_MODERATE' => '$$',
      'PRICE_LEVEL_EXPENSIVE' => '$$$',
      'PRICE_LEVEL_VERY_EXPENSIVE' => '$$$$'
    }.freeze

    def initialize(data, client:)
      @data = data
      @client = client
    end

    def id
      @data['id']
    end

    def name
      @data.dig('displayName', 'text')
    end

    def image_url
      return @image_url if defined?(@image_url)

      photo_name = @data.dig('photos', 0, 'name')
      @image_url =
        if photo_name.present?
          @client.get_json(
            "/#{photo_name}/media",
            query: { maxHeightPx: 400, skipHttpRedirect: true }
          )['photoUri']
        end
    end

    def image_attribution
      author&.dig('displayName').presence
    end

    def image_attribution_url
      author&.dig('uri').presence
    end

    def url
      @data['googleMapsUri'].presence || maps_search_url
    end

    def review_count
      @data['userRatingCount']
    end

    def rating
      @data['rating']
    end

    def price
      PRICE_LEVELS[@data['priceLevel']]
    end

    def address1
      address_lines[0]
    end

    def address2
      address_lines[1].presence
    end

    def address3
      address_lines[2].presence
    end

    def city
      @data.dig('postalAddress', 'locality')
    end

    def state
      @data.dig('postalAddress', 'administrativeArea').presence
    end

    def zip_code
      @data.dig('postalAddress', 'postalCode').presence
    end

    def country
      @data.dig('postalAddress', 'regionCode')
    end

    private

    def address_lines
      Array(@data.dig('postalAddress', 'addressLines'))
    end

    def author
      @data.dig('photos', 0, 'authorAttributions', 0)
    end

    def maps_search_url
      query = CGI.escape(name.to_s)
      place_id = CGI.escape(id.to_s)
      "https://www.google.com/maps/search/?api=1&query=#{query}&query_place_id=#{place_id}"
    end

  end
end
