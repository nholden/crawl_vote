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
    expect(crawl_data.dig('crawlSpots', 'areFetched')).to eql true
    expect(crawl_data.dig('crawlSpots', 'nodes').count).to eql 1
    expect(crawl_data.dig('crawlSpots', 'nodes').first['currentUserVoteId']).to be_present
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
            areFetched
            nodes {
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
