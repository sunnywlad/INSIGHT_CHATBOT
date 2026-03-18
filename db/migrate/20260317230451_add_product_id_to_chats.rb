class AddProductIdToChats < ActiveRecord::Migration[7.1]
  def change
    add_reference :chats, :product, null: false, foreign_key: true
  end
end
