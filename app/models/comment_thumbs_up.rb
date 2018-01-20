class CommentThumbsUp < ActiveRecord::Base


  # 点赞
  def CommentThumbsUp.thumbs_up(user_id, comment)
    thumbs_up = CommentThumbsUp.new
    thumbs_up[:user_id]=user_id
    thumbs_up[:comment_id]=comment[:id]
    if CommentThumbsUp.where('user_id = ? and comment_id = ?', user_id, comment[:id]).length > 0
      return false, 1 # 点过赞了
    end
    if thumbs_up.save
      comment.update_attributes(:thumbs_up_num => comment[:thumbs_up_num]+1)
      return true, 0
    else
      return false, 0 # 点赞失败
    end
  end

  def CommentThumbsUp.find_thumbs_up(user_id, comment_id)
    r = CommentThumbsUp.where('user_id = ? and comment_id = ?', user_id, comment_id)
    return r.length > 0
  end

  # 取消点赞
  def CommentThumbsUp.un_thumbs_up(user_id, comment)
    unless CommentThumbsUp.where('user_id = ? and comment_id = ?', user_id, comment[:id]).length > 0
      return false, 1 # 没点过赞
    end
    if CommentThumbsUp.where('user_id = ? and comment_id = ?', user_id, comment[:id]).delete_all
      comment.update_attributes(:thumbs_up_num => comment[:thumbs_up_num]-1)
      return true, 0
    else
      return false, 0 # 取消点赞失败
    end
  end

end
