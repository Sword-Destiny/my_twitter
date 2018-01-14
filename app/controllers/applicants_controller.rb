class ApplicantsController < ApplicationController
  def new
  end

  def create
    password = params[:password]
    password_repeat = params[:password_repeat]
    name = params[:name]
    if password ==nil or password ==''
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '密码不能为空'}.to_json}
      end
      return
    end
    if name ==nil or name ==''
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '名字不能为空'}.to_json}
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
    user = User.register(name, password)
    if user
      session[:current_user] = user
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
  end
end
