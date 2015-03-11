class User
	include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessor :password

  field :is_active, type: Boolean, :default => true
  field :username, type: String
  field :pet_name, type: String
  field :email, type: String
  field :password_digest, type: String
  field :favorites, type: Array, :default => []

  mount_uploader :image, AvatarUploader

  has_many :pictures

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :username, presence: true, uniqueness: {case_sensitive: false}, length: {in: 1..20}
  validates :pet_name, presence: true
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true, length: {in: 5..50}, confirmation: true, 
            unless: "self.password_digest.present? && self.password.blank?"
  validates :password_digest, presence: true, if: "self.password.blank?"

  before_save do
    self.username = username.downcase
    self.email = email.downcase
    hash_password(self.password)
  end

  def authenticate(password_attempt)
  	BCrypt::Password.new(self.password_digest).is_password?(password_attempt) && self
  end

  def is_active?
    is_active
  end

  def add_favorite(picture)
    self.add_to_set(favorites: picture.id.to_s)
  end

  def remove_favorite(picture)
    self.pull_all(favorites: [picture.id.to_s])
  end

  def favorited?(picture)
    self.favorites.index(picture.id.to_s).present?
  end

  private

    def hash_password(new_password)
      self.password_digest = BCrypt::Password.create(new_password) unless new_password.blank?
    end

end
