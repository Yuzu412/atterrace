class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :tweets, dependent: :destroy
  has_many :likes
  has_many :liked_tweets, through: :likes, source: :tweet
  has_many :liked_blogs, through: :likes, source: :blog
  has_one_attached :image
  validates :name, presence: true
  validates :profile, length: { maximum: 200 }


  has_many :comments, dependent: :destroy
  has_many :group_users
  has_many :groups, through: :group_users
  has_many :blogs, dependent: :destroy
end
