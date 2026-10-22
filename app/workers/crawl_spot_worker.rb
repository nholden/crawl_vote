class CrawlSpotWorker

  include Sidekiq::Worker

  def perform(crawl_id)
    crawl = Crawl.find(crawl_id)
    places = GooglePlaces::TextSearch.new(term: crawl.term, location: crawl.location).places

    places.each do |place|
      spot = Spot.find_or_initialize_by(google_place_id: place.id)
      spot.name = place.name
      spot.image_url = place.image_url
      spot.image_attribution = place.image_attribution
      spot.image_attribution_url = place.image_attribution_url
      spot.url = place.url
      spot.review_count = place.review_count
      spot.rating = place.rating
      spot.price = place.price
      spot.address1 = place.address1
      spot.address2 = place.address2
      spot.address3 = place.address3
      spot.city = place.city
      spot.state = place.state
      spot.zip_code = place.zip_code
      spot.country = place.country
      spot.save! if spot.changed?
      crawl.crawl_spots.find_or_create_by!(spot: spot)
    end

    crawl.spots_fetched = true
    crawl.save!

    Pusher.trigger("crawl-#{crawl.token}", 'crawl-updated', {
      message: 'Crawl updated!'
    })
  end

end
