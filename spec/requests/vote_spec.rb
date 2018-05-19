require 'rails_helper'

RSpec.describe "votes" do

  let(:user_uuid) { SecureRandom.uuid }
  let(:crawl_spot) { FactoryBot.create(:crawl_spot) }

  scenario "successfully creating a vote" do
    post votes_path,
         params: { vote: { crawl_spot_id: crawl_spot.id } },
         headers: { 'Authorization': "Bearer \"#{user_uuid}\"" }

    expect(crawl_spot.votes.count).to eql 1
    expect(crawl_spot.votes.first.user_uuid).to eql user_uuid
    expect(response.status).to eql 201
  end

  scenario "attempting to create a vote without a user_uuid" do
    post votes_path,
         params: { vote: { crawl_spot_id: crawl_spot.id } }

    expect(crawl_spot.votes.count).to eql 0
    expect(response.status).to eql 401
    expect(response.body).to include 'HTTP Token: Access denied.'
  end

  scenario "attempting to create a vote without a crawl_spot_id" do
    post votes_path,
         params: { vote: { crawl_spot_id: nil } },
         headers: { 'Authorization': "Bearer \"#{user_uuid}\"" }

    expect(crawl_spot.votes.count).to eql 0
    expect(response.status).to eql 400
    expect(JSON.parse(response.body)['crawl_spot_id']).to include "can't be blank"
  end

  scenario "attempting to create a duplicate vote" do
    FactoryBot.create(:vote, crawl_spot: crawl_spot, user_uuid: user_uuid)
    post votes_path,
         params: { vote: { crawl_spot_id: crawl_spot.id } },
         headers: { 'Authorization': "Bearer \"#{user_uuid}\"" }

    expect(crawl_spot.votes.count).to eql 1
    expect(crawl_spot.votes.first.user_uuid).to eql user_uuid
    expect(response.status).to eql 400
    expect(JSON.parse(response.body)['user_uuid']).to include "already has a vote for crawl_spot_id"
  end

end
