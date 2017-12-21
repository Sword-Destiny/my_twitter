class PersonalHomepageController < ApplicationController
  def new
    @home_user_id = params[:session][:home_user_id]
    @user = params[:current_user] #使用 ['attr'] 而非 [:attr]
  end

  def update_head_picture
  end

  def send_im_info
  end

  def read_im_info
  end

  def add_tag
  end

  def delete_tag
  end

  def update_name
  end

  def update_password
  end

  def follow
  end

  def unfollow
  end
end
