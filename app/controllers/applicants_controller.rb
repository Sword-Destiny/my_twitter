class ApplicantsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.register(user_params)
    if @user
      session[:current_user] = @user
      redirect_to :sessions_new
    else
      render 'new'
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end
end
