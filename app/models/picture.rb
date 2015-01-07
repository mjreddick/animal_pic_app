class Picture
  include Mongoid::Document
  # field :url, type: String
  field :title, type: String
  field :caption, type: String
  field :category, type: String

  mount_uploader :image, PictureUploader

  belongs_to :user

  def url
  	self.image.url
  end
  
end
