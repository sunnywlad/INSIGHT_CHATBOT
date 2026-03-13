class CreateInsights < ActiveRecord::Migration[7.1]
  def change
    create_table :insights do |t|
      t.references :chat, null: false, foreign_key: true
      t.text :summary
      t.jsonb :sources
      t.string :sentiment

      t.timestamps
    end
  end
end
