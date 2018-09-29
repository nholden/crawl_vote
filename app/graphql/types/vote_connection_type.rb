module Types
  class VoteConnectionType < GraphQL::Types::Relay::BaseConnection

    edge_type(VoteEdgeType)

    field :totalCount, Integer, "How many votes the crawl spot has received", null: false

    def total_count
      object.parent.votes_count
    end

    field :areAnyByCurrentUser, Boolean, "Whether the current user has voted for the crawl spot", null: true

    def are_any_by_current_user
      object.nodes.where(user_uuid: context[:current_user_uuid]).any?
    end

  end
end
