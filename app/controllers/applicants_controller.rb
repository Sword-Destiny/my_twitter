class ApplicantsController < ApplicationController
  def new
    @user = User.new
    @im_info = ImInfo.new
  end

  def create
    @user = User.create(user_params)
    @user[:unread_info_num] = 1
    if @user.save
      # 增加一条私信，从系统发送给新用户
      @im_info[:from] = 1
      @im_info[:to] = @user[:id]
      @im_info[:info] = 'Wellcome to our website!'
      @im_info[:read] = 0
      if @im_info.save
      end
      session[:current_user] = user
      redirect_to :sessions_new_url
    else
      render 'new'
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end
end
