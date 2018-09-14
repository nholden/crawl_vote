module Mutations
  class DeleteVote < Mutations::BaseMutation

    null true

    argument :id, ID, required: true

    field :errors, [String], null: false

    def resolve(id:)
      @vote = Vote.find_by_id(id)

      if @vote&.user_uuid == Current.user_uuid
        @vote.destroy
        trigger_crawl_update
        {
          errors: [],
        }
      elsif @vote
        {
          errors: ["Vote does not belong to current user"],
        }
      else
        {
          errors: ["Vote not found"]
        }
      end
    end

    private

    def trigger_crawl_update
      Pusher.trigger("crawl-#{@vote.crawl.token}", 'crawl-updated', {
        message: 'Crawl updated!'
      })
    end

  end
end
