class TweetThumbsUp < ActiveRecord::Base

  # 点赞
  def TweetThumbsUp.thumbs_up(user_id, tweet_id)
    user = User.find_by(id: user_id)
    tweet = Tweet.find_by(id: tweet_id)
    if user and tweet
      thumbs_up = TweetThumbsUp.new
      thumbs_up[:user_id]=user_id
      thumbs_up[:tweet_id]=tweet_id
      if thumbs_up.save
        tweet.update_attributes(:thumbs_up_num => tweet[:thumbs_up_num]+1)
        true
      else
        false # 点赞失败
      end
    else
      false # 用户或者tweet不存在
    end
  end

  # 取消点赞
  def TweetThumbsUp.un_thumbs_up(user_id, tweet_id)
    tweet = Tweet.find_by(id: tweet_id)
    unless tweet # tweet不存在
      false
    end
    if TweetThumbsUp.delete_all('user_id = ? and tweet_id = ?', user_id, tweet_id)
      tweet.update_attributes(:thumbs_up_num => tweet[:thumbs_up_num]-1)
      true
    else
      false # 点赞不存在
    end
  end

end
