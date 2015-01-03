class Picture
  include Mongoid::Document
  field :url, type: String
  field :title, type: String
  field :caption, type: String
  field :category, type: String
end
