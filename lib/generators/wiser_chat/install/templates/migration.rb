class CreateWiserChatMessages < ActiveRecord::Migration
  def change
    create_table :wiser_chat_messages do |t|
      t.references :user, index: true
      t.text :channel
      t.text :content

      t.timestamps null: false
    end
  end
end