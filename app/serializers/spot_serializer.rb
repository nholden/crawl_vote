class SpotSerializer < ActiveModel::Serializer

  attributes(
    :id,
    :name,
    :rating,
    :review_count,
    :url,
    :image_url,
    :address1,
    :city,
    :state
  )

end
