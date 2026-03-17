class Product < ApplicationRecord
  has_many :products, dependent: :destroy
end
