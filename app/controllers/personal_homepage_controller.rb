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
    s_id = params[:sender_id]
    r_id = params[:receiver_id]
    receiver = User.find_by(id: r_id)
    sender = User.find_by(id: s_id)
    unless sender
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '发送者不存在'}.to_json}
      end
    end
    unless receiver
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '接收者不存在'}.to_json}
      end
    end
    im = params[:im]
    if ImInfo.send_im_info(s_id, r_id, im)
      receiver.update_attribute(:unread_info_num, receiver[:unread_info_num]+1)
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'success', :info => '发送成功'}.to_json}
      end
    else
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '发送失败'}.to_json}
      end
    end
  end

  def read_im_info
    if params[:read_num] == 'one'
      read_one_im_info
    else
      read_all_im_info
    end
  end

  def read_one_im_info
    info_id = params[:info_id]
    if ImInfo.read_im_info(info_id)
      session[:current_user]['unread_info_num']-=1
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'success', :info => '已读'}.to_json}
      end
    else
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '失败'}.to_json}
      end
    end
  end

  def read_all_im_info
    receiver_id = params[:receiver_id]
    if ImInfo.read_all_im_info(receiver_id)
      session[:current_user]['unread_info_num']=0
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'success', :info => '全部已读'}.to_json}
      end
    else
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '失败'}.to_json}
      end
    end
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
    user_id = params[:user_id]
    follower_id = params[:follower_id]
    user = User.find_by(id: user_id)
    follower = User.find_by(id: follower_id)
    unless user
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '被关注者不存在'}.to_json}
      end
    end
    unless follower
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '当前用户不存在'}.to_json}
      end
    end
    if Follow.add_follow(user_id, follower_id)
      # user.update_attribute(:follower_num, user[:follower_num]+1)
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'success', :info => '关注成功'}.to_json}
      end
    else
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '关注失败'}.to_json}
      end
    end
  end

  def unfollow
    user_id = params[:user_id]
    follower_id = params[:follower_id]
    user = User.find_by(id: user_id)
    follower = User.find_by(id: follower_id)
    unless user
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '被关注者不存在'}.to_json}
      end
    end
    unless follower
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '当前用户不存在'}.to_json}
      end
    end
    if Follow.delete_follow(user_id, follower_id)
      # user.update_attribute(:follower_num, user[:follower_num]+1)
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'success', :info => '已取消关注'}.to_json}
      end
    else
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '取消关注失败'}.to_json}
      end
    end
  end

end
