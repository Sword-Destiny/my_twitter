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
    im = params[:im]
    s_id = params[:sender_id]
    r_id = params[:receiver_id]
    receiver = User.find_by(id: r_id)
    sender = User.find_by(id: s_id)
    if im == nil or im == ''
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '不能发送空消息'}.to_json}
      end
      return
    end
    unless sender
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '发送者不存在'}.to_json}
      end
      return
    end
    unless receiver
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '接收者不存在'}.to_json}
      end
      return
    end
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
    user = User.find_by(id: session[:current_user]['id'])
    unless user
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '用户不存在'}.to_json}
      end
      return
    end
    newtag = params[:newtag]
    if newtag == nil or newtag == ''
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '标签为空'}.to_json}
      end
      return
    end
    usertag = UserTag.add_user_tag(newtag, user)
    if usertag
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'success', :info => '成功', :id => usertag[:id]}.to_json}
      end
    else
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '添加失败'}.to_json}
      end
    end
  end

  def delete_tag
    user = User.find_by(id: session[:current_user]['id'])
    unless user
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '用户不存在'}.to_json}
      end
      return
    end
    tag_id = params[:id]
    if UserTag.delete_user_tag(tag_id, user)
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'success', :info => '成功'}.to_json}
      end
    else
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '删除失败'}.to_json}
      end
    end
  end

  def update_name
    newname = params[:newname]
    user_id = session[:current_user]['id']
    if newname == nil or newname==''
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '用户名为空'}.to_json}
      end
      return
    end
    r = User.update_name(user_id, newname)
    if r
      session[:current_user]['name']=newname
      params[:home_user_id]=user_id
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'success', :info => '成功'}.to_json}
      end
    else
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '失败'}.to_json}
      end
    end
    r
  end

  def update_password
    password = params[:password]
    password_repeat = params[:password_repeat]
    if password ==nil or password ==''
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '密码不能为空'}.to_json}
      end
      return
    end
    unless password == password_repeat
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '密码不一致'}.to_json}
      end
      return
    end
    user = User.find_by(id: session[:current_user]['id'])
    unless user
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '用户不存在'}.to_json}
      end
      return
    end
    User.update_password(user, password)
    respond_to do |format|
      format.js
      format.html
      format.json {render :json => {:status => 'success', :info => '成功'}.to_json}
    end
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
      return
    end
    unless follower
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '当前用户不存在'}.to_json}
      end
      return
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
      return
    end
    unless follower
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '当前用户不存在'}.to_json}
      end
      return
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
