class Chat < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy
  has_many :insights, dependent: :destroy

  validates :title, presence: true
end
