class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  validates :title, :presence => true, :uniqueness => true, :length => 5..140
  validates :body, :presence => true, :length => {minimum: 140}
  validates_presence_of :user_id
end
