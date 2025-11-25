class Tweet < ApplicationRecord
  belongs_to :user
  belongs_to :group   # どのグループの投稿かを紐付け
  has_many_attached :images
  has_many :likes, as: :likeable
  has_many :liked_users, through: :likes, source: :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many_attached :images

  validate :images_presence   # ← ここで呼ぶ

  private

  def images_presence
    errors.add(:images, "を1枚以上アップロードしてください") unless images.attached?
  end
end
