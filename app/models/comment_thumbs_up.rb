class CommentThumbsUp < ActiveRecord::Base

  # 点赞
  def CommentThumbsUp.thumbs_up(user_id, comment_id)
    user = User.find_by(id: user_id)
    comment = Comment.find_by(id: comment_id)
    if user and comment
      thumbs_up = CommentThumbsUp.new
      thumbs_up[:user_id]=user_id
      thumbs_up[:comment_id]=comment_id
      if thumbs_up.save
        comment.update_attributes(:thumbs_up_num => comment[:thumbs_up_num] + 1)
        true
      else
        false # 点赞失败
      end
    else
      false # 用户或者评论不存在
    end
  end

  # 取消点赞
  def CommentThumbsUp.un_thumbs_up(user_id, comment_id)
    comment = Comment.find_by(id: comment_id)
    unless comment # 评论不存在
      false
    end
    if CommentThumbsUp.delete_all('user_id = ? and comment_id = ?', user_id, comment_id)
      comment.update_attributes(:thumbs_up_num => comment[:thumbs_up_num] - 1)
      true
    else
      false # 点赞不存在
    end
  end

end
