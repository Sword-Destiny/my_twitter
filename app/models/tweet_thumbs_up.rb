class TweetThumbsUp < ActiveRecord::Base

  # 点赞
  def TweetThumbsUp.thumbs_up(user_id, tweet)
    thumbs_up = TweetThumbsUp.new
    thumbs_up[:user_id]=user_id
    thumbs_up[:tweet_id]=tweet[:id]
    if TweetThumbsUp.where('user_id = ? and tweet_id = ?', user_id, tweet[:id]).length > 0
      return false, 1 # 点过赞了
    end
    if thumbs_up.save
      tweet.update_attributes(:thumbs_up_num => tweet[:thumbs_up_num]+1)
      return true, 0
    else
      return false, 0 # 点赞失败
    end
  end

  def TweetThumbsUp.find_thumbs_up(user_id, tweet_id)
    r = TweetThumbsUp.where('user_id = ? and tweet_id = ?', user_id, tweet_id)
    return r.length > 0
  end

  # 取消点赞
  def TweetThumbsUp.un_thumbs_up(user_id, tweet)
    unless TweetThumbsUp.where('user_id = ? and tweet_id = ?', user_id, tweet[:id]).length > 0
      return false, 1 # 没点过赞
    end
    if TweetThumbsUp.where('user_id = ? and tweet_id = ?', user_id, tweet[:id]).delete_all
      tweet.update_attributes(:thumbs_up_num => tweet[:thumbs_up_num]-1)
      return true, 0
    else
      return false, 0 # 取消点赞失败
    end
  end

end
