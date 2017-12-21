class CreateTweetThumbsUps < ActiveRecord::Migration
  def change
    create_table :tweet_thumbs_ups do |t|
      t.integer :tweet_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
