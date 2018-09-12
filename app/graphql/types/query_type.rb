module Types
  class QueryType < Types::BaseObject

    field :crawl, CrawlType, null: true do
      description "Find a Crawl by ID"
      argument :id, ID, required: true
    end

    def crawl(id:)
      Crawl.find(id)
    end

  end
end
