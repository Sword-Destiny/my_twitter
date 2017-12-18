class UserAddColumnHeadPicture < ActiveRecord::Migration
  def change
    add_column :users, :head_picture, :string
  end
end
