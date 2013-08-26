class FeedItem < MotionResource::Base
  attr_accessor :id
  attribute :name, :address, :phone, :distance, :description, :link, :website
  self.collection_url = 'feed'
  self.member_url = 'feed/:id'

  def details
    [:name, :address, :phone, :distance, :description, :link].map { |attr|
      self.send(attr)
    }.join(' ')
  end
end
