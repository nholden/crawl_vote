FactoryBot.define do
  factory :crawl do
    term 'Mexican'
    location 'Ocean Beach, San Diego'
    token { TokenPhrase.generate }
  end
end
