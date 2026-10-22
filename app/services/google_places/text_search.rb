module GooglePlaces
  class TextSearch

    PAGE_SIZE = 5
    FIELD_MASK = %w[
      places.id
      places.displayName
      places.postalAddress
      places.googleMapsUri
      places.rating
      places.userRatingCount
      places.priceLevel
      places.photos.name
      places.photos.authorAttributions
    ].join(',').freeze

    def initialize(term:, location:, client: Client.new)
      @term = term
      @location = location
      @client = client
    end

    def places
      body = @client.post_json(
        '/places:searchText',
        body: {
          textQuery: "#{@term} in #{@location}",
          pageSize: PAGE_SIZE,
          openNow: true
        },
        field_mask: FIELD_MASK
      )

      Array(body['places']).filter_map do |data|
        next if data['id'].blank? || data.dig('displayName', 'text').blank?

        Place.new(data, client: @client)
      end
    end

  end
end
