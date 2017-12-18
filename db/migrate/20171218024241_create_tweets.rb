class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.integer :user_id
      t.string :contents
      t.integer :comment_num
      t.integer :thumbs_up_num
      t.integer :transmit_num
      t.string :transmit_from_id

      t.timestamps null: false
    end
  end
end
