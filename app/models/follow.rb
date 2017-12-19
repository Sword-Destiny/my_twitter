class Follow < ActiveRecord::Base

  def Follow.add_follow(user_id, follower_id)
    user = User.find_by(id: user_id)
    follower = User.find_by(id: follower_id)
    if user and follower
      follow = Follow.new
      follow[:user_id] = user_id
      follow[:follower_id] = follower_id
      follow.save
    else
      false # 用户不存在
    end
  end

  def Follow.delete_follow(user_id, follower_id)
    Follow.delete_all('user_id = ? and follower_id = ?', user_id, follower_id)
  end

end
