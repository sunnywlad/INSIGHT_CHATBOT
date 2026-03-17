class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :product
  has_many :messages, dependent: :destroy
  has_many :insights, dependent: :destroy
end
