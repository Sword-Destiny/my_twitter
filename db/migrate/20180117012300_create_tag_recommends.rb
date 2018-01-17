class CreateTagRecommends < ActiveRecord::Migration
  def change
    create_table :tag_recommends do |t|
      t.integer :tweet_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
