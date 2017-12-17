class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :password_digest
      t.integer :unread_info_num

      t.timestamps null: false
    end
  end
end
