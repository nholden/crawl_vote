require 'rails_helper'

RSpec.describe "view crawl" do

  let!(:crawl) { FactoryBot.create(:crawl,
                                   spots_fetched: spots_fetched,
                                   term: 'coffee',
                                   location: 'Javaville, USA') }

  context "when the spots have been fetched for the crawl" do
    let(:spots_fetched) { true }

    scenario "viewing an existing crawl with a spot" do
      spot = FactoryBot.create(:spot)
      FactoryBot.create(:crawl_spot, crawl: crawl, spot: spot)

      visit root_url
      click_link 'Join a crawl'
      fill_in 'Code', with: crawl.token
      click_button 'Join Crawl'

      expect(page).to have_text spot.name.upcase
    end

    scenario "viewing an existing crawl without any spots" do
      visit root_url
      click_link 'Join a crawl'
      fill_in 'Code', with: crawl.token
      click_button 'Join Crawl'

      expect(page).to have_text 'Couldn’t find coffee in Javaville, USA'
    end
  end

  context "when the spots have been fetched for the crawl" do
    let(:spots_fetched) { false }

    scenario "viewing an existing crawl" do
      visit root_url
      click_link 'Join a crawl'
      fill_in 'Code', with: crawl.token
      click_button 'Join Crawl'

      expect(page).to have_text 'Finding coffee in Javaville, USA'
    end
  end

end
