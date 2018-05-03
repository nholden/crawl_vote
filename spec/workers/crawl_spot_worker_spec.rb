require 'rails_helper'

RSpec.describe CrawlSpotWorker do

  Given(:worker) { CrawlSpotWorker.new }
  Given(:crawl) { FactoryBot.create(:crawl) }

  describe "#perform", :vcr do
    When { worker.perform(crawl.id) }
    Then { crawl.spots.count == 5 }
  end

end
