class PostVotes < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  validates :post_id, uniqueness: {scope: :user_id}
  validates :value, inclusion: { in: [1, -1], message: "%{value} is not a valid vote" }
end
