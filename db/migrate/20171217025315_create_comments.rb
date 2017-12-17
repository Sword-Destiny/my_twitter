class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :tweet_id
      t.string :contents
      t.integer :thumbs_up_num
      t.integer :replyed_num
      t.integer :reply_comment_id
      t.integer :top_comment_id

      t.timestamps null: false
    end
  end
end
