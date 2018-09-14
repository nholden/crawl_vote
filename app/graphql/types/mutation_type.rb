module Types
  class MutationType < Types::BaseObject

    field :create_vote, mutation: Mutations::CreateVote
    field :delete_vote, mutation: Mutations::DeleteVote

  end
end
