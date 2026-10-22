require 'rails_helper'

RSpec.describe GooglePlaces::TextSearch do

  describe '#places' do
    Given { ENV['GOOGLE_PLACES_API_KEY'] = 'test-key' }
    Given(:search) { GooglePlaces::TextSearch.new(term: term, location: location) }
    Given(:term) { 'Mexican' }
    Given(:location) { 'Ocean Beach' }

    context 'with a matching place' do
      Given(:photo_name) { 'places/ChIJexample/photos/AbC' }
      Given(:search_body) do
        {
          places: [
            {
              id: 'ChIJexample',
              displayName: { text: "Hugo's Cocina", languageCode: 'en' },
              googleMapsUri: 'https://maps.google.com/?cid=1',
              rating: 4.5,
              userRatingCount: 190,
              priceLevel: 'PRICE_LEVEL_MODERATE',
              postalAddress: {
                regionCode: 'US',
                postalCode: '92107',
                administrativeArea: 'CA',
                locality: 'San Diego',
                addressLines: ['1830 Sunset Cliffs Blvd']
              },
              photos: [
                {
                  name: photo_name,
                  authorAttributions: [
                    {
                      displayName: 'Ada Lovelace',
                      uri: 'https://maps.google.com/maps/contrib/1'
                    }
                  ]
                }
              ]
            }
          ]
        }
      end
      Given do
        stub_request(:post, 'https://places.googleapis.com/v1/places:searchText')
          .with(
            headers: {
              'X-Goog-Api-Key' => 'test-key',
              'X-Goog-FieldMask' => GooglePlaces::TextSearch::FIELD_MASK
            }
          ) do |request|
            body = JSON.parse(request.body)
            body['textQuery'] == 'Mexican in Ocean Beach' &&
              body['pageSize'] == 5 &&
              body['openNow'] == true
          end
          .to_return(status: 200, body: search_body.to_json, headers: { 'Content-Type' => 'application/json' })

        stub_request(:get, 'https://places.googleapis.com/v1/places/ChIJexample/photos/AbC/media')
          .with(query: hash_including('maxHeightPx' => '400', 'skipHttpRedirect' => 'true'))
          .to_return(
            status: 200,
            body: { photoUri: 'https://lh3.googleusercontent.com/photo' }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end
      When(:result) { search.places }

      Then { result.count == 1 }

      Given(:place) { result.first }
      And { place.is_a? GooglePlaces::Place }
      And { place.id == 'ChIJexample' }
      And { place.name == "Hugo's Cocina" }
      And { place.image_url == 'https://lh3.googleusercontent.com/photo' }
      And { place.image_attribution == 'Ada Lovelace' }
      And { place.image_attribution_url == 'https://maps.google.com/maps/contrib/1' }
      And { place.url == 'https://maps.google.com/?cid=1' }
      And { place.review_count == 190 }
      And { place.rating == 4.5 }
      And { place.price == '$$' }
      And { place.address1 == '1830 Sunset Cliffs Blvd' }
      And { place.address2.nil? }
      And { place.address3.nil? }
      And { place.city == 'San Diego' }
      And { place.state == 'CA' }
      And { place.zip_code == '92107' }
      And { place.country == 'US' }
    end

    context 'when a place has no photo or Maps link' do
      Given do
        stub_request(:post, 'https://places.googleapis.com/v1/places:searchText')
          .to_return(
            status: 200,
            body: {
              places: [
                {
                  id: 'ChIJbare',
                  displayName: { text: 'Bare Spot' },
                  priceLevel: 'PRICE_LEVEL_FREE'
                }
              ]
            }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end
      When(:result) { search.places }

      Then { result.count == 1 }
      And { result.first.image_url.nil? }
      And { result.first.image_attribution.nil? }
      And { result.first.price.nil? }
      And { result.first.rating.nil? }
      And { result.first.review_count.nil? }
      And { result.first.url == 'https://www.google.com/maps/search/?api=1&query=Bare+Spot&query_place_id=ChIJbare' }
    end

    context 'when no places match' do
      Given do
        stub_request(:post, 'https://places.googleapis.com/v1/places:searchText')
          .to_return(status: 200, body: '{}', headers: { 'Content-Type' => 'application/json' })
      end
      When(:result) { search.places }

      Then { result == [] }
    end

    context 'when the API returns an error' do
      Given do
        stub_request(:post, 'https://places.googleapis.com/v1/places:searchText')
          .to_return(status: 403, body: 'permission denied')
      end
      When(:result) { search.places }

      Then { result == Failure(RuntimeError, /403/) }
    end
  end

end
