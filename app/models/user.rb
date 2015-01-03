class User
  include Mongoid::Document
  # field :active?, type: Boolean
  field :username, type: String
  field :pet_name, type: String
  field :email, type: String
  field :password, type: String
end
