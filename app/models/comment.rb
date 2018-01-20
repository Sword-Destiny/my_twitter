class Comment < ActiveRecord::Base

  # 是否顶级评论(评论分为两级)
  def Comment.is_top_comment(comment)
    comment[:top_comment_id] == -1
  end

  # 获取所有评论
  def Comment.list_comments(tweet_id, user_id)
    comments = Comment.where('tweet_id = ?', tweet_id)
    users = User.where('id in (select user_id from  comments where tweet_id = ?)', tweet_id)
    comments_list = []
    comments.each do |comment|
      if is_top_comment(comment)
        thumbsup = CommentThumbsUp.find_thumbs_up(user_id, comment[:id])
        user = users.find_by(id: comment[:user_id])
        comments_list.push({:top_comment_id => comment[:id], :thumbsup => thumbsup, :username => user[:name], :top_comment => comment, :elements => []})
      end
    end

    comments.each do |c|
      comments_list.each do |item|
        if item[:top_comment_id] == c[:top_comment_id]
          reply_comment = comments.find_by(id: c[:reply_comment_id])
          reply_user = users.find_by(id: reply_comment[:user_id])
          user = users.find_by(id: c[:user_id])
          thumbsup = CommentThumbsUp.find_thumbs_up(user_id, c[:id])
          item[:elements].push({:username => user[:name], :thumbsup => thumbsup, :reply_username => reply_user[:name], :comment => c})
          break
        end
      end
    end

    comments_list
  end

  # 删除评论
  def Comment.delete_comments(comment_id)
    comment = Comment.find_by(id: comment_id)
    if comment
      # 删除可能会失败
      Comment.where('id = ? or top_comment_id = ?', comment_id, comment_id).delete_all
    else
      false #评论不存在
    end
  end

  def Comment.reply_top_comment(contents, user_id, tweet, top_comment)
    comment = Comment.new
    comment[:tweet_id] = tweet[:id]
    comment[:contents] = contents
    comment[:thumbs_up_num] = 0
    comment[:replyed_num] = 0
    comment[:top_comment_id] = top_comment[:id]
    comment[:reply_comment_id] = top_comment[:id]
    comment[:user_id] = user_id
    if comment.save
      top_comment.update_attributes(:replyed_num => top_comment[:replyed_num] + 1)
      tweet.update_attributes(:comment_num => tweet[:comment_num] + 1)
      comment
    else
      nil #保存comment失败
    end
  end

  # 回复comment
  def Comment.reply_comment(contents, user_id, tweet, top_comment, replyed_comment)
    comment = Comment.new
    comment[:tweet_id] = tweet[:id]
    comment[:contents] = contents
    comment[:thumbs_up_num] = 0
    comment[:replyed_num] = 0
    comment[:top_comment_id] = replyed_comment[:top_comment_id]
    comment[:reply_comment_id] = replyed_comment[:id]
    comment[:user_id] = user_id
    if comment.save
      replyed_comment.update_attributes(:replyed_num => replyed_comment[:replyed_num] + 1)
      top_comment.update_attributes(:replyed_num => top_comment[:replyed_num] + 1)
      tweet.update_attributes(:comment_num => tweet[:comment_num] + 1)
      comment
    else
      nil #保存comment失败
    end
  end

  # 搜索comment
  def Comment.search_comment(user_id, keyword)
    if user_id>=0
      # 搜索自己的
      Comment.where('id = ? and contents like "%?%"', user_id, keyword)
    else
      Comment.where('contents like %?%', keyword)
    end
  end

  # 发布comment
  def Comment.post_comment(contents, user_id, tweet)
    comment = Comment.new
    comment[:tweet_id] = tweet[:id]
    comment[:contents] = contents
    comment[:thumbs_up_num] = 0
    comment[:replyed_num] = 0
    comment[:top_comment_id] = -1
    comment[:reply_comment_id] = -1
    comment[:user_id] = user_id
    if comment.save
      tweet.update_attributes(:comment_num => tweet[:comment_num] + 1)
      return comment
    else
      return nil #保存comment失败
    end
  end

end
