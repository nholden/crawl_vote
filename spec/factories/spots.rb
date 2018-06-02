FactoryBot.define do
  factory :spot do
    rating 1.5
    price "$"
    review_count 1
    name "Spot's Spot"
    url "spotsspot.spot"
    image_url "https://spotsspot.spot/spot.gif"
    city "Spotsville"
    country "USA"
    address1 "123 Spot Street"
    address2 "Unit 1"
    address3 "Wat"
    state "CA"
    zip_code "92101"
  end
end
