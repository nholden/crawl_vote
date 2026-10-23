require 'rails_helper'

RSpec.describe "view crawl" do

  def set_viewport(width, height)
    page.driver.browser.execute_cdp(
      "Emulation.setDeviceMetricsOverride",
      width: width,
      height: height,
      deviceScaleFactor: 1,
      mobile: width < 768
    )
  end

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

      show_qr = find_button('Show QR code')
      dialog_id = show_qr['commandfor']
      expect(show_qr['command']).to eq('show-modal')
      expect(dialog_id).to be_present

      click_button 'Show QR code'

      dialog = find('dialog[open]')
      expect(dialog['id']).to eq(dialog_id)
      expect(dialog['closedby']).to eq('any')
      expect(dialog['aria-label']).to eq('QR code for the share link')
      expect(dialog.text).to eq('')

      qr = dialog.find('img')
      expect(qr['src']).to start_with('data:image/png;base64,')
      expect(qr['src'].length).to be > 500

      [[360, 700], [320, 568], [740, 360]].each do |width, height|
        set_viewport(width, height)
        rect = dialog.rect
        qr_rect = qr.rect
        viewport_width, viewport_height = page.evaluate_script('[window.innerWidth, window.innerHeight]')

        expect(rect.x).to be >= -1
        expect(rect.y).to be >= -1
        expect(rect.x + rect.width).to be <= viewport_width + 1
        expect(rect.y + rect.height).to be <= viewport_height + 1
        expect(qr_rect.width).to be >= 120
        expect(qr_rect.x).to be >= rect.x - 1
        expect(qr_rect.x + qr_rect.width).to be <= rect.x + rect.width + 1
        expect(page.evaluate_script("document.querySelector('dialog[open]').scrollHeight <= document.querySelector('dialog[open]').clientHeight + 1")).to eq(true)
      end

      page.driver.browser.execute_cdp("Emulation.clearDeviceMetricsOverride")
      page.current_window.resize_to(1100, 800)
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
