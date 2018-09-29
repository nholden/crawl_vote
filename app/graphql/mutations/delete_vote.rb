module Mutations
  class DeleteVote < Mutations::BaseMutation

    description "Delete a vote for the current user on a crawl spot"

    null true

    argument :crawl_spot_id, ID, required: true

    field :errors, [String], null: false

    def resolve(crawl_spot_id:)
      @vote = Vote.find_by(crawl_spot_id: crawl_spot_id, user_uuid: Current.user_uuid)

      if @vote
        @vote.destroy
        trigger_crawl_update
        {
          errors: [],
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
