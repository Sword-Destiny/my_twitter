class CreateHotRecommends < ActiveRecord::Migration
  def change
    create_table :hot_recommends do |t|
      t.integer :tweet_id

      t.timestamps null: false
    end
  end
end
