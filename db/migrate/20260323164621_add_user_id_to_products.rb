class AddUserIdToProducts < ActiveRecord::Migration[7.1]
  def change
    add_reference :products, :user, null: true, foreign_key: true
    Product.update_all(user_id: User.first.id)
    change_column_null :products, :user_id, false
  end
end
