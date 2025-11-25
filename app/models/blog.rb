class Blog < ApplicationRecord
  belongs_to :group
  belongs_to :user
  has_one_attached :image
  has_many :likes, as: :likeable
  has_many :liked_users, through: :likes, source: :user
  has_many :comments, as: :commentable, dependent: :destroy
end
