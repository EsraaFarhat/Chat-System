class CreateChats < ActiveRecord::Migration[7.0]
  def change
    create_table :chats do |t|
      t.belongs_to :application
      t.integer :number, null: false
      t.integer :messages_count, null: false, default: 0
      t.timestamps
    end
    add_index :chats, [:application_id, :number], unique: true
  end

  def down
    drop_table :chats
  end
end