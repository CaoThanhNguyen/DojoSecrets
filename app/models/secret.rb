class Secret < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :users_like, through: :likes, source: :user

  validates :content, presence: true
end
