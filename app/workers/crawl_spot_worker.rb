class CrawlSpotWorker

  def perform(crawl_id)
    crawl = Crawl.find(crawl_id)
    businesses = Yelp::BusinessSearch.new(term: crawl.term, location: crawl.location).businesses

    businesses.each do |business|
      spot = Spot.find_or_initialize_by(yelp_id: business.id)
      spot.name = business.name
      spot.image_url = business.image_url
      spot.url = business.url
      spot.review_count = business.review_count
      spot.rating = business.rating
      spot.price = business.price
      spot.address1 = business.address1
      spot.address2 = business.address2
      spot.address3 = business.address3
      spot.city = business.city
      spot.state = business.state
      spot.zip_code = business.zip_code == '92107'
      spot.country = business.country
      spot.distance = business.distance
      spot.save! if spot.changed?
      crawl.spots << spot
    end

    crawl.save!
  end

end
