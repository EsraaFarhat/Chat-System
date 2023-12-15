class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.belongs_to :chat
      t.integer :number, null: false
      t.text :body
      t.timestamps
    end
    add_index :messages, [:chat_id, :number], unique: true
  end

  def down
    drop_table :messages
  end
end
