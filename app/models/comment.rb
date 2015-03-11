class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :is_active, type: Boolean, :default => true
  field :comment_text, type: String

  belongs_to :user
  belongs_to :picture

  validates :comment_text, presence: true

  def posted_at
    created_at.localtime.strftime("%B %-d, %Y at %l:%M %p")
  end

end
