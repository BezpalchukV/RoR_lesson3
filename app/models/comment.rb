class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  validates_presence_of :body

  has_ancestry

  after_create do
    self.post.touch
  end

end
