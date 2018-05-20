require 'rails_helper'

RSpec.describe CrawlSpotWorker do

  Given(:worker) { CrawlSpotWorker.new }
  Given(:crawl) { FactoryBot.create(:crawl) }

  describe "#perform", :vcr do
    When { worker.perform(crawl.id) }

    Then { crawl.spots.count == 5 }

    Given(:spot) { crawl.spots.first }
    And { spot.yelp_id.present? }
    And { spot.name == "Mike's Taco Club" }
    And { spot.image_url.present? }
    And { spot.url.present? }
    And { spot.review_count == 542 }
    And { spot.rating == 4.5 }
    And { spot.price == '$' }
    And { spot.address1 == '5060 Newport Ave' }
    And { spot.address2.nil? }
    And { spot.address3.nil? }
    And { spot.city == 'San Diego' }
    And { spot.state == 'CA' }
    And { spot.zip_code == '92107' }
    And { spot.country == 'US' }
  end

end
