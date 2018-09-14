require 'rails_helper'

RSpec.describe "crawls" do

  let(:user_uuid) { SecureRandom.uuid }
  let(:crawl) { FactoryBot.create(:crawl, term: 'Acai Bowl', location: 'Golden Hill, San Diego') }
  let!(:crawl_spot) { FactoryBot.create(:crawl_spot, crawl: crawl) }
  let!(:vote) { FactoryBot.create(:vote, crawl_spot: crawl_spot, user_uuid: user_uuid) }

  scenario "successfully fetching crawl data" do
    query = <<-'GRAPHQL'
      query Crawl($token: String!) {
        crawl(token: $token) {
          term
          location
          spotsFetched
          token
          crawlSpots {
            id
            votesCount
            currentUserVoteId
            spot {
              id
              name
              rating
              reviewCount
              url
              imageUrl
              address1
              city
              state
            }
          }
        }
      }
    GRAPHQL

    post graphql_path,
      params: {
        query: query,
        variables: {
          token: crawl.token,
        },
      },
      headers: {
        'Authorization': "Bearer \"#{user_uuid}\"",
      }

    crawl_data = JSON.parse(response.body).dig('data', 'crawl')
    expect(response.status).to eql 200
    expect(crawl_data['term']).to eql 'Acai Bowl'
    expect(crawl_data['location']).to eql 'Golden Hill, San Diego'
    expect(crawl_data['crawlSpots'].count).to eql 1
    expect(crawl_data['crawlSpots'].first['currentUserVoteId']).to be_present
  end

  scenario "attempting to fetch crawl data without a user_uuid" do
    query = <<-'GRAPHQL'
      query Crawl($token: String!) {
        crawl(token: $token) {
          term
          location
          spotsFetched
          token
          crawlSpots {
            id
            votesCount
            currentUserVoteId
            spot {
              id
              name
              rating
              reviewCount
              url
              imageUrl
              address1
              city
              state
            }
          }
        }
      }
    GRAPHQL

    post graphql_path,
      params: {
        query: query,
        variables: {
          token: crawl.token,
        },
      }

    expect(response.status).to eql 401
    expect(response.body).to include 'HTTP Token: Access denied.'
  end

end
