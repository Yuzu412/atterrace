class Group < ApplicationRecord
  has_many :group_users
  has_many :users, through: :group_users
  has_many :tweets
  has_many :blogs, dependent: :destroy
  validates :name, presence: true, uniqueness: true
  has_many_attached :images
  # 招待トークン（Group.new_token で呼び出す）
    def self.new_token
      SecureRandom.urlsafe_base64
    end
 
    # ユーザーがこのグループにすでに参加しているか確認する
    def joined?(user)
      self.users.include?(user)
    end

end
