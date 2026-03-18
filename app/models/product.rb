class Product < ApplicationRecord
  has_many :chats, dependent: :destroy
end
