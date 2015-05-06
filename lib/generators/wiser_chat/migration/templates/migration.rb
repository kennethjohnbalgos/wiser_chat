class CreateWiserChatMessages < ActiveRecord::Migration
  def change
    create_table :wiser_chat_messages do |t|
      t.references :user, index: true
      t.text :channel
      t.text :content

      t.timestamps null: false
    end
    add_foreign_key :messages, :users
  end
end