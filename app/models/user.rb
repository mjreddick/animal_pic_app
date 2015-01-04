class User
  include Mongoid::Document

  attr_reader :password
  # attr_accessor :password_confirmation

  # field :active?, type: Boolean
  field :username, type: String
  field :pet_name, type: String
  field :email, type: String
  field :password_digest, type: String

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :username, presence: true, uniqueness: {case_sensitive: false}, length: {in: 1..20}
  validates :pet_name, presence: true
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true, length: {in: 5..50}, confirmation: true

  def password=(new_password)
  	@password = new_password
  	self.password_digest = BCrypt::Password.create(new_password)
  end

end
