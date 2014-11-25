class User < ActiveRecord::Base
  has_secure_password

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :post_voteses

  validates_presence_of :password_digest
  validates :name, :email,
            presence: true,
            uniqueness: true
end
