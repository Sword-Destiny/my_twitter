class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(name: user_params[:name]).try(:authenticate, user_params[:password])
    if user
      session[:current_user] = user
      render 'new'
    else
      flash.now[:error_info] = 'Name Or Password Error!'
      render 'new'
    end
  end

  def post_tweet
    user = session[:current_user]
    if user == nil
      flash.now[:error_info] = sprintf('Please log in fitst!')
      render 'new' # TODO 改成ajax
      nil
    else
      t = Tweet.add_tweet(user['id'], params[:content])
      if t
        render 'new' # TODO 改成ajax
        t
      else
        nil
      end
    end
  end

  private
  def user_params
    params.require(:session).permit(:name, :password)
  end
end
