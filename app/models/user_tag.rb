class UserTag < ActiveRecord::Base

  # 打标签
  def UserTag.add_user_tag(tag, user_id)
    user = User.find_by(id: user_id)
    if user
      user_tag = UserTag.new
      user_tag[:tag]=tag
      user_tag[:user_id]=user_id
      user_tag.save
    else
      false # user不存在
    end
  end

  # 删除标签
  def UserTag.delete_user_tag(tag, user_id)
    user = User.find_by(id: user_id)
    unless user # user不存在
      false
    end
    UserTag.delete_all('tag = ? and user_id = ?', tag, user_id)
  end

end
