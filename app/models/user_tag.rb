class UserTag < ActiveRecord::Base

  # 打标签
  def UserTag.add_user_tag(tag, user)
    user_tag = UserTag.new
    user_tag[:tag]=tag
    user_tag[:user_id]=user[:id]
    user_tag.save
    user_tag
  end

  # 删除标签
  def UserTag.delete_user_tag(tag_id, user)
    UserTag.where('id = ? and user_id = ?', tag_id, user[:id]).delete_all
  end

  # 列出所有标签
  def UserTag.list_tags(user_id)
    UserTag.where('user_id = ?',user_id)
  end

end
