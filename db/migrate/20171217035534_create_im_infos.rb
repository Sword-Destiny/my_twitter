class CreateImInfos < ActiveRecord::Migration
  def change
    create_table :im_infos do |t|
      t.integer :from
      t.integer :to
      t.string :info
      t.integer :read

      t.timestamps null: false
    end
  end
end
