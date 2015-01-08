class Picture
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :caption, type: String
  field :category, type: String

  mount_uploader :image, PictureUploader

  belongs_to :user

  def url
  	self.image.url
  end

  def posted_at
    created_at.localtime.strftime("%B %-d, %Y at %l:%M %p")
  end
  
end
