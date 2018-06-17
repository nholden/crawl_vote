require 'rails_helper'

RSpec.describe "crawls" do

  let(:user_uuid) { SecureRandom.uuid }
  let(:crawl) { FactoryBot.create(:crawl, term: 'Acai Bowl', location: 'Golden Hill, San Diego') }
  let!(:crawl_spot) { FactoryBot.create(:crawl_spot, crawl: crawl) }
  let!(:vote) { FactoryBot.create(:vote, crawl_spot: crawl_spot, user_uuid: user_uuid) }

  scenario "successfully fetching crawl data" do
    get api_crawl_path(crawl),
        headers: { 'Authorization': "Bearer \"#{user_uuid}\"" }

    parsed_response = JSON.parse(response.body)
    expect(response.status).to eql 200
    expect(parsed_response['term']).to eql 'Acai Bowl'
    expect(parsed_response['location']).to eql 'Golden Hill, San Diego'
    expect(parsed_response['crawl_spots'].count).to eql 1
    expect(parsed_response['crawl_spots'].first['current_user_vote']).to be_present
  end

  scenario "attempting to fetch crawl data without a user_uuid" do
    get api_crawl_path(crawl)

    expect(response.status).to eql 401
    expect(response.body).to include 'HTTP Token: Access denied.'
  end

end
