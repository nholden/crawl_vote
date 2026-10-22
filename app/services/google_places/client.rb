module GooglePlaces
  class Client

    BASE_URL = 'https://places.googleapis.com/v1'.freeze

    def initialize(api_key: ENV.fetch('GOOGLE_PLACES_API_KEY'))
      @api_key = api_key
    end

    def post_json(path, body:, field_mask:)
      request(
        :post,
        path,
        body: JSON.generate(body),
        field_mask: field_mask
      )
    end

    def get_json(path, query:)
      request(:get, path, query: query)
    end

    private

    def request(method, path, body: nil, query: nil, field_mask: nil)
      headers = { 'X-Goog-Api-Key' => @api_key }
      headers['Content-Type'] = 'application/json' if body
      headers['X-Goog-FieldMask'] = field_mask if field_mask

      response = Excon.public_send(
        method,
        "#{BASE_URL}#{path}",
        headers: headers,
        body: body,
        query: query
      )

      if response.status == 200
        JSON.parse(response.body.presence || '{}')
      else
        raise "Google Places API returned a #{response.status} status: #{response.body}"
      end
    end

  end
end
