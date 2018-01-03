class PersonalHomepageController < ApplicationController
  def new
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
    newname = params[:personal_homepage][:newname]
    user_id = session[:current_user]['id']
    if User.update_name(user_id, newname)
      session[:current_user]['name']=newname
      params[:home_user_id]=user_id
      render 'new'
    else
      false
    end
  end

  def update_password
  end

  def follow
  end

  def unfollow
  end

end
