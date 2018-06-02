require 'rails_helper'

RSpec.describe "view crawl" do

  let!(:crawl) { FactoryBot.create(:crawl) }
  let!(:spot) { FactoryBot.create(:spot) }
  let!(:crawl_spot) { FactoryBot.create(:crawl_spot, crawl: crawl, spot: spot) }

  scenario "viewing an existing crawl" do
    visit root_url
    click_link 'Join a crawl'
    fill_in 'Code', with: crawl.token
    click_button 'Join Crawl'

    expect(page).to have_text spot.name.upcase
  end

end
