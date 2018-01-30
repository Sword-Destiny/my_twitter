class TweetTag < ActiveRecord::Base

  # 打标签
  def TweetTag.add_tweet_tag(tag, tweet)
    tweet_tag = TweetTag.new
    tweet_tag[:tag]=tag
    tweet_tag[:tweet_id]=tweet[:id]
    tweet_tag.save
    tweet_tag
  end

  # 删除标签
  def TweetTag.delete_tweet_tag(tag_id, tweet)
    TweetTag.where('id = ? and tweet_id = ?', tag_id, tweet[:id]).delete_all
  end

  # 列出所有tag
  def TweetTag.list_tags(tweet_id)
    TweetTag.where('tweet_id = ?',tweet_id)
  end

end
