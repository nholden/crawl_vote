module Types
  class VoteConnectionType < GraphQL::Types::Relay::BaseConnection

    edge_type(VoteEdgeType)

    field :total_count, Integer, "How many votes the crawl spot has received", null: false

    def total_count
      object.parent.votes_count
    end

    field :are_any_by_current_user, Boolean, "Whether the current user has voted for the crawl spot", null: true

    def are_any_by_current_user
      object.items.where(user_uuid: context[:current_user_uuid]).any?
    end

  end
end
