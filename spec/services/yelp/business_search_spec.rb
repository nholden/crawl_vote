require 'rails_helper'

RSpec.describe Yelp::BusinessSearch do

  describe "#businesses" do
    Given(:business_search) { Yelp::BusinessSearch.new(term: term, location: location) }
    When(:result) { business_search.businesses }

    context "with a valid term and location", :vcr do
      Given(:term) { 'Mexican' }
      Given(:location) { 'Ocean Beach' }

      Then { result.count == 5 }

      Given(:business) { result.first }
      And { business.is_a? Yelp::Business }
      And { business.id.present? }
      And { business.name == "Hugo's Cocina" }
      And { business.image_url.present? }
      And { business.url.present? }
      And { business.review_count == 190 }
      And { business.rating == 4.5 }
      And { business.price == '$$' }
      And { business.address1 == '1830 Sunset Cliffs Blvd' }
      And { business.address2.nil? }
      And { business.address3.nil? }
      And { business.city == 'San Diego' }
      And { business.state == 'CA' }
      And { business.zip_code == '92107' }
      And { business.country == 'US' }
    end

    context "with an invalid term", :vcr do
      Given(:term) { 'fhqwhgads' }
      Given(:location) { 'Ocean Beach' }

      Then { result == [] }
    end

    context "with an invalid location", :vcr do
      Given(:term) { 'Mexican' }
      Given(:location) { 'fhqwhgads' }

      Then { result == [] }
    end
  end

end
