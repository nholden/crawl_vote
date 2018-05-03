module Yelp
  class Business

    def initialize(data)
      @data = data
    end

    def id
      @data['id']
    end

    def name
      @data['name']
    end

    def image_url
      @data['image_url']
    end

    def url
      @data['url']
    end

    def review_count
      @data['review_count']
    end

    def rating
      @data['rating']
    end

    def price
      @data['price']
    end

    def address1
      @data.dig('location', 'address1')
    end

    def address2
      @data.dig('location', 'address2').presence
    end

    def address3
      @data.dig('location', 'address3').presence
    end

    def city
      @data.dig('location', 'city')
    end

    def state
      @data.dig('location', 'state').presence
    end

    def zip_code
      @data.dig('location', 'zip_code').presence
    end

    def country
      @data.dig('location', 'country')
    end

    def distance
      @data['distance']
    end

  end
end
