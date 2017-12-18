class Comment < ActiveRecord::Base

  # 是否顶级评论(评论分为两级)
  def is_top_comment
    if :top_comment_id == -1
      true
    else
      false
    end
  end

  # 获取所有评论
  def Comment.list_comments(tweet_id)
    Comment.where('tweet_id = ?', tweet_id)
  end

  # 删除评论
  def Comment.delete_comments(comment_id)
    comment = Comment.find_by(id: comment_id)
    if comment
      # 删除可能会失败
      Comment.delete_all('id = ? or top_comment_id = ?', comment_id, comment_id)
    else
      false # 评论不存在
    end
  end

  # 回复comment
  def Comment.reply_comment(contents, user_id, tweet_id, replyed_comment_id)
    replyed_comment = Comment.find_by(id: replyed_comment_id)
    tweet = Tweet.find_by(id: tweet_id)
    if replyed_comment and tweet
      comment = Comment.new
      if replyed_comment.is_top_comment
        comment[:tweet_id] = tweet_id
        comment[:contents] = contents
        comment[:thumbs_up_num] = 0
        comment[:replyed_num] = 0
        comment[:top_comment_id] = replyed_comment_id
        comment[:reply_comment_id] = replyed_comment_id
        comment[:user_id] = user_id
        if comment.save
          replyed_comment[:replyed_num] += 1
          tweet[:comment_num] += 1
          replyed_comment.update
          tweet.update
        else
          nil #保存comment失败
        end
      else
        top_comment = Comment.find_by(id: replyed_comment[:top_comment_id])
        unless top_comment
          nil #原comment已被删除
        end
        comment[:tweet_id] = tweet_id
        comment[:contents] = contents
        comment[:thumbs_up_num] = 0
        comment[:replyed_num] = 0
        comment[:top_comment_id] = replyed_comment[:top_comment_id]
        comment[:reply_comment_id] = replyed_comment_id
        comment[:user_id] = user_id
        if comment.save
          replyed_comment[:replyed_num] += 1
          top_comment[:replyed_num] += 1
          tweet[:comment_num] += 1
          top_comment.update
          replyed_comment.update
          tweet.update
        else
          nil #保存comment失败
        end
      end
    else
      nil #原comment或者原tweet已被删除
    end
  end

  # 发布comment
  def Comment.post_comment(contents, user_id, tweet_id)
    comment = Comment.new
    comment[:tweet_id] = tweet_id
    comment[:contents] = contents
    comment[:thumbs_up_num] = 0
    comment[:replyed_num] = 0
    comment[:top_comment_id] = -1
    comment[:reply_comment_id] = -1
    comment[:user_id] = user_id
    if comment.save
      comment
    else
      nil #保存comment失败
    end
  end

end
