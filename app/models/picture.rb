class Picture
  include Mongoid::Document
  include Mongoid::Timestamps

  field :is_active, type: Boolean, :default => true
  field :title, type: String
  field :caption, type: String, :default => ""
  field :fiended_by, type: Array, :default => []
  field :friended_by, type: Array, :default => []
  field :total_votes, type: Integer, :default => 0
  field :is_friend, type: Boolean, :default => false

  mount_uploader :image, PictureUploader

  belongs_to :user

  validates :title, presence: true
  validates :image, presence: true

  def posted_at
    created_at.localtime.strftime("%B %-d, %Y at %l:%M %p")
  end

  # add a user's id to the friended_by list
  # a given user id can only be in one list at a time and have only one entry in that list
  def vote_friend(voter)
    self.inc(total_votes: 1) unless voted_friend?(voter) || voted_fiend?(voter)
    self.pull_all(fiended_by: [voter.id.to_s])
    self.add_to_set(friended_by: voter.id.to_s)
    self.is_friend = self.friended_by.length > self.fiended_by.length
  end

  # add a user's id to the fiended_by list
  # a given user id can only be in one list at a time and have only one entry in that list
  def vote_fiend(voter)
    self.inc(total_votes: 1) unless voted_friend?(voter) || voted_fiend?(voter)
    self.pull_all(friended_by: [voter.id.to_s])
    self.add_to_set(fiended_by: voter.id.to_s)
    self.is_friend = self.friended_by.length > self.fiended_by.length
  end

  #check if someone voted for friend
  def voted_friend?(voter)
    self.friended_by.index(voter.id.to_s).present?
  end

  #check if someone voted for fiend
  def voted_fiend?(voter)
    self.fiended_by.index(voter.id.to_s).present?
  end

  def is_friend?
    self.is_friend
  end

  def is_active?
    is_active
  end    
end
