class Comment < ActiveRecord::Base

  # 是否顶级评论(评论分为两级)
  def Comment.is_top_comment(comment)
    comment[:top_comment_id] == -1
  end

  # 获取所有评论
  def Comment.list_comments(tweet_id)
    comments = Comment.where('tweet_id = ?', tweet_id)
    users = User.where('id in (select user_id from  comments where tweet_id = ?)', tweet_id)
    comments_list = []
    comments.each do |comment|
      if is_top_comment(comment)
        user = users.find_by(id: comment[:user_id])
        comments_list.push({:top_comment_id => comment[:id], :username => user[:name], :top_comment => comment, :elements => []})
      end
    end

    comments.each do |c|
      comments_list.each do |item|
        if item[:top_comment_id] == c[:top_comment_id]
          reply_comment = comments.find_by(id: c[:reply_comment_id])
          reply_user = users.find_by(id: reply_comment[:user_id])
          user = users.find_by(id: c[:user_id])
          item[:elements].push({:username => user[:name], :reply_username => reply_user[:name], :comment => c})
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
      Comment.delete_all('id = ? or top_comment_id = ?', comment_id, comment_id)
    else
      false #评论不存在
    end
  end

  # 回复comment
  def Comment.reply_comment(contents, user_id, tweet_id, replyed_comment_id)
    replyed_comment = Comment.find_by(id: replyed_comment_id)
    tweet = Tweet.find_by(id: tweet_id)
    if replyed_comment and tweet
      comment = Comment.new
      if is_top_comment(replyed_comment)
        comment[:tweet_id] = tweet_id
        comment[:contents] = contents
        comment[:thumbs_up_num] = 0
        comment[:replyed_num] = 0
        comment[:top_comment_id] = replyed_comment_id
        comment[:reply_comment_id] = replyed_comment_id
        comment[:user_id] = user_id
        if comment.save
          replyed_comment.update_attributes(:replyed_num => replyed_comment[:replyed_num] + 1)
          tweet.update_attributes(:comment_num => tweet[:comment_num] + 1)
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
          replyed_comment.update_attributes(:replyed_num => replyed_comment[:replyed_num] + 1)
          top_comment.update_attributes(:replyed_num => top_comment[:replyed_num] + 1)
          tweet.update_attributes(:comment_num => tweet[:comment_num] + 1)
        else
          nil #保存comment失败
        end
      end
    else
      nil #原comment或者原tweet已被删除
    end
  end

  # 搜索comment
  def Comment.search_comment(user_id, keyword)
    if user_id>=0
      # 搜索自己的
      Comment.where('id = ? and contents like %?%', user_id, keyword)
    else
      Comment.where('contents like %?%', keyword)
    end
  end

  # 发布comment
  def Comment.post_comment(contents, user_id, tweet_id)
    tweet = Tweet.find_by(id: tweet_id)
    unless tweet
      nil # tweet不存在
    end
    comment = Comment.new
    comment[:tweet_id] = tweet_id
    comment[:contents] = contents
    comment[:thumbs_up_num] = 0
    comment[:replyed_num] = 0
    comment[:top_comment_id] = -1
    comment[:reply_comment_id] = -1
    comment[:user_id] = user_id
    if comment.save
      tweet.update_attributes(:comment_num => tweet[:comment_num] + 1)
    else
      nil #保存comment失败
    end
  end

end
