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

      visit root_path
      click_link 'Join a crawl'
      fill_in 'Code', with: crawl.token
      click_button 'Join Crawl'

      # The spot name is rendered with Tailwind's uppercase utility.
      expect(page).to have_text(/#{Regexp.escape(spot.name)}/i)
      expect(page).to have_text("Based on #{spot.review_count} reviews")
      expect(page).to have_link('Google Maps', href: spot.url)
      expect(page).to have_css(%([aria-label="Rated #{spot.rating} out of 5"]))

      share_button = find_button('Copy share link')
      expect(share_button['data-share-url']).to eq(page.current_url)

      share_button.click
      expect(page).to have_button('Copied!')
    end

    scenario "sharing a crawl with a QR code" do
      visit root_path
      click_link 'Join a crawl'
      fill_in 'Code', with: crawl.token
      click_button 'Join Crawl'

      expect(page).to have_text 'Couldn’t find coffee in Javaville, USA'
      expect(page).not_to have_css('dialog[open]')

      click_button 'Show QR code'

      dialog = find('dialog[open]')
      expect(dialog['closedby']).to eq('any')
      expect(dialog).to have_text('Share this crawl')
      expect(dialog).to have_text('Scan this code to join the vote.')
      expect(dialog).to have_text(page.current_url)

      qr = dialog.find('img[alt="QR code for the share link"]')
      expect(qr['src']).to start_with('data:image/png;base64,')
      expect(qr['src'].length).to be > 500

      click_button 'Close'
      expect(page).not_to have_css('dialog[open]')

      click_button 'Show QR code'
      find('dialog[open]').send_keys(:escape)
      expect(page).not_to have_css('dialog[open]')

      click_button 'Show QR code'
      page.driver.browser.action.move_to_location(8, 8).click.perform
      expect(page).not_to have_css('dialog[open]')

      click_button 'Copy share link'
      expect(page).to have_button('Copied!')
    end

    scenario "viewing an existing crawl without any spots" do
      visit root_path
      click_link 'Join a crawl'
      fill_in 'Code', with: crawl.token
      click_button 'Join Crawl'

      expect(page).to have_text 'Couldn’t find coffee in Javaville, USA'
    end
  end

  context "when the spots have been fetched for the crawl" do
    let(:spots_fetched) { false }

    scenario "viewing an existing crawl" do
      visit root_path
      click_link 'Join a crawl'
      fill_in 'Code', with: crawl.token
      click_button 'Join Crawl'

      expect(page).to have_text 'Finding coffee in Javaville, USA'
    end
  end

end
