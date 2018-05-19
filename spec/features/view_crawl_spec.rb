require 'rails_helper'

RSpec.describe "view crawl" do

  let!(:crawl) { FactoryBot.create(:crawl) }

  scenario "successfully viewing an existing crawl" do
    visit crawl_path(crawl)
    expect(page.status_code).to eql 200
  end

end
