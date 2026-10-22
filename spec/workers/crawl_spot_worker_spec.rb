require 'rails_helper'

RSpec.describe CrawlSpotWorker do

  Given(:worker) { CrawlSpotWorker.new }
  Given(:crawl) { FactoryBot.create(:crawl, spots_fetched: false) }
  Given(:place) do
    instance_double(
      GooglePlaces::Place,
      id: 'ChIJexample',
      name: "Hugo's Cocina",
      image_url: 'https://lh3.googleusercontent.com/photo',
      image_attribution: 'Ada Lovelace',
      image_attribution_url: 'https://maps.google.com/maps/contrib/1',
      url: 'https://maps.google.com/?cid=1',
      review_count: 190,
      rating: 4.5,
      price: '$$',
      address1: '1830 Sunset Cliffs Blvd',
      address2: nil,
      address3: nil,
      city: 'San Diego',
      state: 'CA',
      zip_code: '92107',
      country: 'US'
    )
  end
  Given(:search) { instance_double(GooglePlaces::TextSearch, places: [place]) }
  Given do
    allow(GooglePlaces::TextSearch).to receive(:new)
      .with(term: crawl.term, location: crawl.location)
      .and_return(search)
  end

  describe '#perform' do
    When { worker.perform(crawl.id) }
    When { crawl.reload }

    Then { crawl.spots.count == 1 }
    And { crawl.spots_fetched == true }

    Given(:spot) { crawl.spots.first }
    And { spot.google_place_id == 'ChIJexample' }
    And { spot.name == "Hugo's Cocina" }
    And { spot.image_url == 'https://lh3.googleusercontent.com/photo' }
    And { spot.image_attribution == 'Ada Lovelace' }
    And { spot.image_attribution_url == 'https://maps.google.com/maps/contrib/1' }
    And { spot.url == 'https://maps.google.com/?cid=1' }
    And { spot.review_count == 190 }
    And { spot.rating == 4.5 }
    And { spot.price == '$$' }
    And { spot.address1 == '1830 Sunset Cliffs Blvd' }
    And { spot.address2.nil? }
    And { spot.address3.nil? }
    And { spot.city == 'San Diego' }
    And { spot.state == 'CA' }
    And { spot.zip_code == '92107' }
    And { spot.country == 'US' }

    context 'when the crawl is fetched again' do
      When { worker.perform(crawl.id) }
      When { crawl.reload }

      Then { crawl.spots.count == 1 }
      And { crawl.crawl_spots.count == 1 }
    end
  end

end
