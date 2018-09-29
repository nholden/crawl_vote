FactoryBot.define do
  factory :crawl do
    term 'Mexican'
    location 'Ocean Beach, San Diego'
    token { TokenPhrase.generate }
    spots_fetched true
  end
end
