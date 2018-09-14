module Types
  class MutationType < Types::BaseObject

    field :create_vote, mutation: Mutations::CreateVote

  end
end
