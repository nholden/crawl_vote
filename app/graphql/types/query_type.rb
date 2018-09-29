module Types
  class QueryType < Types::BaseObject

    field :crawl, CrawlType, null: true do
      description "Find a Crawl by token"
      argument :token, String, required: true
    end

    def crawl(token:)
      Crawl.find_by_token(token)
    end

  end
end
