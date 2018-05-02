require 'rails_helper'

RSpec.describe "create crawl" do

  scenario "creating a crawl for Mexican near Ocean Beach, San Diego" do
    visit root_url
    fill_in 'Find', with: 'Mexican'
    fill_in 'Near', with: 'Ocean Beach, San Diego'
    click_button 'Create Crawl'

    crawl = Crawl.last!

    expect(crawl.term).to eql 'Mexican'
    expect(crawl.location).to eql 'Ocean Beach, San Diego'
    expect(page).to have_text 'Creating crawl for Mexican in Ocean Beach, San Diego'
  end

end
