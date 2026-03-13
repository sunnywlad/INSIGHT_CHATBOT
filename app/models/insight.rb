class Insight < ApplicationRecord
  belongs_to :chat

  validates :summary, presence: true
end
