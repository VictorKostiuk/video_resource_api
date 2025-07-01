class Channel < ApplicationRecord
  has_one_attached :avatar

  belongs_to :user
  has_many :posts, dependent: :destroy
end
