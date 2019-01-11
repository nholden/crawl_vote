require 'rails_helper'

RSpec.describe "crawls" do

  let(:user_uuid) { SecureRandom.uuid }
  let(:crawl) { FactoryBot.create(:crawl, term: 'Acai Bowl', location: 'Golden Hill, San Diego', spots_fetched: true) }
  let!(:crawl_spot) { FactoryBot.create(:crawl_spot, crawl: crawl) }
  let!(:vote) { FactoryBot.create(:vote, crawl_spot: crawl_spot, user_uuid: user_uuid) }

  scenario "successfully fetching crawl data" do
    query = <<-'GRAPHQL'
      query Crawl($token: String!) {
        crawl(token: $token) {
          term
          location
          token
          crawlSpots {
            areFetched
            nodes {
              id
              votes {
                totalCount
                areAnyByCurrentUser
              }
              spot {
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

    expect(response.status).to eql 200

    crawl_data = JSON.parse(response.body).dig('data', 'crawl')
    expect(crawl_data['term']).to eql 'Acai Bowl'
    expect(crawl_data['location']).to eql 'Golden Hill, San Diego'

    crawl_spots_data = crawl_data['crawlSpots']
    expect(crawl_spots_data['areFetched']).to eql true
    expect(crawl_spots_data['nodes'].count).to eql 1

    votes_data = crawl_spots_data['nodes'].first['votes']
    expect(votes_data['totalCount']).to eql 1
    expect(votes_data['areAnyByCurrentUser']).to eql true
  end

  scenario "successfully fetching crawl data when location data is nil" do
    spot = FactoryBot.create(:spot, address1: nil, city: nil, state: nil)
    crawl_spot.update! spot: spot

    query = <<-'GRAPHQL'
      query Crawl($token: String!) {
        crawl(token: $token) {
          term
          location
          token
          crawlSpots {
            areFetched
            nodes {
              id
              votes {
                totalCount
                areAnyByCurrentUser
              }
              spot {
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

    expect(response.status).to eql 200
    expect(response.body).to_not include 'Cannot return null for non-nullable field'

    crawl_spot_nodes = JSON.parse(response.body).dig('data', 'crawl', 'crawlSpots', 'nodes')
    spot_data = crawl_spot_nodes.first['spot']
    expect(spot_data['name']).to eql(spot.name)
    expect(spot_data['address1']).to eql(nil)
    expect(spot_data['city']).to eql(nil)
    expect(spot_data['state']).to eql(nil)
  end

  scenario "attempting to fetch crawl data without a user_uuid" do
    query = <<-'GRAPHQL'
      query Crawl($token: String!) {
        crawl(token: $token) {
          term
          location
          token
          crawlSpots {
            areFetched
            nodes {
              id
              votes {
                totalCount
                areAnyByCurrentUser
              }
              spot {
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

  scenario "successfully creating a crawl" do
    query = <<-'GRAPHQL'
      mutation CreateCrawl($term: String!, $location: String!) {
        createCrawl(input: { term: $term, location: $location }) {
          token
          errors
        }
      }
    GRAPHQL

    post graphql_path,
      params: {
        query: query,
        variables: {
          term: "Korean BBQ",
          location: "Allston, MA"
        },
      },
      headers: {
        'Authorization': "Bearer \"user_uuid_1234\"",
      }

    data = JSON.parse(response.body).dig('data', 'createCrawl')
    expect(response.status).to eql 200
    expect(data['token']).to be_present
  end

  scenario "attempting to create a crawl without a term" do
    query = <<-'GRAPHQL'
      mutation CreateCrawl($term: String!, $location: String!) {
        createCrawl(input: { term: $term, location: $location }) {
          token
          errors
        }
      }
    GRAPHQL

    post graphql_path,
      params: {
        query: query,
        variables: {
          term: nil,
          location: "Allston, MA"
        },
      },
      headers: {
        'Authorization': "Bearer \"user_uuid_1234\"",
      }

    expect(response.status).to eql 200
    expect(response.body).to include "Variable term of type String! was provided invalid value"
  end

  scenario "attempting to create a crawl without a location" do
    query = <<-'GRAPHQL'
      mutation CreateCrawl($term: String!, $location: String!) {
        createCrawl(input: { term: $term, location: $location }) {
          token
          errors
        }
      }
    GRAPHQL

    post graphql_path,
      params: {
        query: query,
        variables: {
          term: "Korean BBQ",
          location: nil
        },
      },
      headers: {
        'Authorization': "Bearer \"user_uuid_1234\"",
      }

    expect(response.status).to eql 200
    expect(response.body).to include "Variable location of type String! was provided invalid value"
  end

  scenario "attempting to create a crawl without a user_uuid" do
    query = <<-'GRAPHQL'
      mutation CreateCrawl($term: String!, $location: String!) {
        createCrawl(input: { term: $term, location: $location }) {
          token
          errors
        }
      }
    GRAPHQL

    post graphql_path,
      params: {
        query: query,
        variables: {
          term: "Korean BBQ",
          location: "Allston, MA",
        },
      },
      headers: {
        'Authorization': nil,
      }

    expect(response.status).to eql 401
  end

end
