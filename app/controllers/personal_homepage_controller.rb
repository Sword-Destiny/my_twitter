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
    newname = params[:newname]
    user_id = session[:current_user]['id']
    r = User.update_name(user_id, newname)
    if r
      session[:current_user]['name']=newname
      params[:home_user_id]=user_id
      respond_to do |format|
        format.js
        format.html
      end
    else
      respond_to do |format|
        format.js
        format.html
      end
    end
    r
  end

  def update_password
  end

  def follow
  end

  def unfollow
  end

end
