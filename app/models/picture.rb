class Picture
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :caption, type: String
  # field :category, type: String

  mount_uploader :image, PictureUploader

  belongs_to :user

  validates :title, presence: true
  validates :image, presence: true

  def posted_at
    created_at.localtime.strftime("%B %-d, %Y at %l:%M %p")
  end
  
end
