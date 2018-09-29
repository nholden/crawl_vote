module Mutations
  class CreateCrawl < Mutations::BaseMutation

    description "Create a crawl"

    null true

    argument :term, String, required: true
    argument :location, String, required: true

    field :token, String, null: true
    field :errors, [String], null: false

    def resolve(term:, location:)
      crawl = Crawl.new(
        term: term,
        location: location
      )

      if crawl.valid?
        crawl.save!
        CrawlSpotWorker.perform_async(crawl.id)
        {
          token: crawl.token,
          errors: [],
        }
      else
        {
          token: nil,
          errors: crawl.errors.full_messages,
        }
      end
    end

  end
end
