class FeedItem < MotionResource::Base
  attr_accessor :id
  attribute :name, :address, :phone, :distance, :description, :link, :website, :longitude, :latitude, :location
  self.collection_url = 'feed'
  self.member_url = 'feed/:id'

  def description=(description)
    @description = description
  end

  def description
    @description
  end

  def title=(title)
    @name = title
  end

  def title
    @name
  end

  def coordinate
    coord = CLLocationCoordinate2D.new
    coord.latitude = latitude
    coord.longitude = longitude
    coord
  end

  def details
    [:name, :address, :phone, :distance, :description, :link].map { |attr|
      self.send(attr)
    }.join(' ')
  end
end
