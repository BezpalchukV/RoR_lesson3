class User < ActiveRecord::Base
  has_secure_password

  has_many :posts
  has_many :comments

  validates_presence_of :password_digest
  validates :name, :email,
            presence: true,
            uniqueness: true
end
