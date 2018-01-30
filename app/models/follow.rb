class Follow < ActiveRecord::Base

  # 关注
  def Follow.add_follow(user_id, follower_id)
    follow = Follow.new
    follow[:user_id] = user_id
    follow[:follower_id] = follower_id
    follow.save
  end

  # 获取所有关注
  def Follow.get_follow(user_id)
    User.where('id in (select user_id from follows where follower_id = ?)', user_id)
  end

  # 获取所有粉丝
  def Follow.get_fans(user_id)
    User.where('id in (select follower_id from follows where user_id = ?)', user_id)
  end

  # 取关
  def Follow.delete_follow(user_id, follower_id)
    Follow.where('user_id = ? and follower_id = ?', user_id, follower_id).delete_all
  end

  # 是否关注
  def Follow.is_follow(user_id, follower_id)
    Follow.where('user_id = ? and follower_id = ?', user_id, follower_id).length > 0
  end

end
