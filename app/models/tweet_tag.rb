class TweetTag < ActiveRecord::Base

  # 打标签
  def TweetTag.add_tweet_tag(tag, tweet_id)
    tweet = Tweet.find_by(id: tweet_id)
    if tweet
      tweet_tag = TweetTag.new
      tweet_tag[:tag]=tag
      tweet_tag[:tweet_id]=tweet_id
      tweet_tag.save
    else
      false # tweet不存在
    end
  end

  # 删除标签
  def TweetTag.delete_tweet_tag(tag, tweet_id)
    tweet = Tweet.find_by(id: tweet_id)
    unless tweet # tweet不存在
      false
    end
    TweetTag.delete_all('tag = ? and tweet_id = ?', tag, tweet_id)
  end

end
