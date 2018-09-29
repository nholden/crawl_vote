require 'rails_helper'

RSpec.describe "votes" do

  let(:user_uuid) { SecureRandom.uuid }
  let(:crawl_spot) { FactoryBot.create(:crawl_spot) }

  scenario "successfully creating a vote" do
    query = <<-'GRAPHQL'
      mutation CreateVote($crawlSpotId: ID!) {
        createVote(input: { crawlSpotId: $crawlSpotId }) {
          errors
        }
      }
    GRAPHQL

    post graphql_path,
      params: {
        query: query,
        variables: {
          crawlSpotId: crawl_spot.id
        },
      },
      headers: {
        'Authorization': "Bearer \"#{user_uuid}\""
      }

    expect(crawl_spot.votes.count).to eql 1
    expect(crawl_spot.votes.first.user_uuid).to eql user_uuid
    expect(response.status).to eql 200
  end

  scenario "attempting to create a vote without a user_uuid" do
    query = <<-'GRAPHQL'
      mutation CreateVote($crawlSpotId: ID!) {
        createVote(input: { crawlSpotId: $crawlSpotId }) {
          errors
        }
      }
    GRAPHQL

    post graphql_path,
      params: {
        query: query,
        variables: {
          crawlSpotId: crawl_spot.id
        },
      }

    expect(crawl_spot.votes.count).to eql 0
    expect(response.status).to eql 401
    expect(response.body).to include 'HTTP Token: Access denied.'
  end

  scenario "attempting to create a vote without a crawlSpotId" do
    query = <<-'GRAPHQL'
      mutation {
        createVote(input: { crawlSpotId: null }) {
          errors
        }
      }
    GRAPHQL

    post graphql_path,
      params: {
        query: query,
      },
      headers: {
        'Authorization': "Bearer \"#{user_uuid}\""
      }

    expect(crawl_spot.votes.count).to eql 0
    expect(response.status).to eql 200
    expect(response.body).to include 'invalid value'
  end

  scenario "attempting to create a duplicate vote" do
    FactoryBot.create(:vote, crawl_spot: crawl_spot, user_uuid: user_uuid)

    query = <<-'GRAPHQL'
      mutation CreateVote($crawlSpotId: ID!) {
        createVote(input: { crawlSpotId: $crawlSpotId }) {
          errors
        }
      }
    GRAPHQL

    post graphql_path,
      params: {
        query: query,
        variables: {
          crawlSpotId: crawl_spot.id
        },
      },
      headers: {
        'Authorization': "Bearer \"#{user_uuid}\""
      }

    expect(crawl_spot.votes.count).to eql 1
    expect(crawl_spot.votes.first.user_uuid).to eql user_uuid
    expect(response.status).to eql 200
    expect(response.body).to include "already has a vote"
  end

  scenario "successfully deleting a vote" do
    vote = FactoryBot.create(:vote, crawl_spot: crawl_spot, user_uuid: user_uuid)

    query = <<-'GRAPHQL'
      mutation DeleteVote($crawlSpotId: ID!) {
        deleteVote(input: { crawlSpotId: $crawlSpotId }) {
          errors
        }
      }
    GRAPHQL

    post graphql_path,
      params: {
        query: query,
        variables: {
          crawlSpotId: crawl_spot.id
        },
      },
      headers: {
        'Authorization': "Bearer \"#{user_uuid}\""
      }

    expect(Vote.find_by_id(vote.id)).to be_nil
    expect(crawl_spot.votes.count).to eql 0
    expect(response.status).to eql 200
  end

  scenario "attempting to delete a vote when all votes for crawl spot belong to other users" do
    vote = FactoryBot.create(:vote, crawl_spot: crawl_spot, user_uuid: 'other-user-uuid')

    query = <<-'GRAPHQL'
      mutation DeleteVote($crawlSpotId: ID!) {
        deleteVote(input: { crawlSpotId: $crawlSpotId }) {
          errors
        }
      }
    GRAPHQL

    post graphql_path,
      params: {
        query: query,
        variables: {
          crawlSpotId: crawl_spot.id
        },
      },
      headers: {
        'Authorization': "Bearer \"#{user_uuid}\""
      }

    expect(Vote.find_by_id(vote.id)).to be_present
    expect(crawl_spot.votes.count).to eql 1
    expect(response.status).to eql 200
    expect(response.body).to include 'Vote not found'
  end

  scenario "attempting to delete a vote that doesn't exist" do
    query = <<-'GRAPHQL'
      mutation DeleteVote($crawlSpotId: ID!) {
        deleteVote(input: { crawlSpotId: $crawlSpotId }) {
          errors
        }
      }
    GRAPHQL

    post graphql_path,
      params: {
        query: query,
        variables: {
          crawlSpotId: 1234
        },
      },
      headers: {
        'Authorization': "Bearer \"#{user_uuid}\""
      }

    expect(response.status).to eql 200
    expect(response.body).to include 'Vote not found'
  end

end
