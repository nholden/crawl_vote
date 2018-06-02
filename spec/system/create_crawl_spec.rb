require 'rails_helper'

RSpec.describe "create crawl" do

  scenario "creating a crawl for Mexican near Ocean Beach, San Diego" do
    visit root_url
    fill_in 'Find', with: 'Mexican'
    fill_in 'Near', with: 'Ocean Beach, San Diego'
    click_button 'Create Crawl'

    expect(page).to have_text 'Finding Mexican in Ocean Beach, San Diego'

    crawl = Crawl.last!
    expect(crawl.term).to eql 'Mexican'
    expect(crawl.location).to eql 'Ocean Beach, San Diego'
    expect(crawl.token).to be_present
    expect(CrawlSpotWorker.jobs.count).to eql 1
  end

  scenario "attempting to create a crawl without a term" do
    visit root_url
    fill_in 'Find', with: ''
    fill_in 'Near', with: 'Ocean Beach, San Diego'
    click_button 'Create Crawl'

    expect(Crawl.count).to eql 0
    expect(CrawlSpotWorker.jobs.count).to eql 0
    expect(page).to have_text 'A search term is required'
  end

  scenario "attempting to create a crawl without a location" do
    visit root_url
    fill_in 'Find', with: 'Mexican'
    fill_in 'Near', with: ''
    click_button 'Create Crawl'

    expect(Crawl.count).to eql 0
    expect(CrawlSpotWorker.jobs.count).to eql 0
    expect(page).to have_text 'A location is required'
  end

end
