class PersonalHomepageController < ApplicationController
  def new
  end

  def update_head_picture
    file = File.read(params[:img_upload].path)
    old_url = session[:current_user]['head_picture']
    r, new_url = User.update_head_picture(session[:current_user]['id'], file, params[:img_upload].original_filename)
    if r
      session[:current_user]['head_picture']=new_url
      json = {:old_url => old_url, :new_url => new_url}.to_json
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => json}
      end
    else
      session[:current_user]['head_picture']=new_url
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:old_url => old_url, :new_url => old_url}.to_json}
      end
    end
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
    oldname = session[:current_user]['name']
    newname = params[:newname]
    user_id = session[:current_user]['id']
    r = User.update_name(user_id, newname)
    if r
      session[:current_user]['name']=newname
      params[:home_user_id]=user_id
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:oldname => oldname}.to_json}
      end
    else
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:oldname => oldname}.to_json}
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
