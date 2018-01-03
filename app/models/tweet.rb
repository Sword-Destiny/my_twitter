class Tweet < ActiveRecord::Base

  # 获取所有tweet
  def Tweet.list_tweets(user_id)
    if user_id!=-1
      my_tweets = Tweet.where('user_id = ?', user_id)
      follow_tweets = Tweet.where('user_id in (select id from follows where follower_id = ?)', user_id)
      user_tweets = my_tweets + follow_tweets
      user_tweets.sort_by! {|t| t[:created_at]}
      user_tweets.reverse!
      recommend_tweets = Tweet.get_recommend_tweets(user_id)
      tweets = user_tweets[0...8] + recommend_tweets
      tweets_list = []
      tweets.each do |tweet|
        user = User.find_by(id: tweet[:user_id])
        tweets_list.push({:username => user[:name], :tweet => tweet})
      end
      tweets_list
    else
      Tweet.get_recommend_tweets(user_id)
    end
  end

  # 搜索tweet
  def Tweet.search_tweet(user_id, keyword)
    if user_id>=0
      # 搜索自己的tweet
      Tweet.where('id = ? and contents like %?%', user_id, keyword)
    else
      Tweet.where('contents like %?%', keyword)
    end
  end

  # 发布tweet
  def Tweet.add_tweet(user_id, contents)
    tweet = Tweet.new
    tweet[:user_id] = user_id
    tweet[:contents] = contents
    tweet[:thumbs_up_num] = 0
    tweet[:transmit_num] = 0
    tweet[:transmit_from_id] = -1
    tweet[:comment_num] = 0
    if tweet.save
      tweet
    else
      nil
    end
  end

  def Tweet.delete_tweet(tweet_id)
    tweet = Tweet.find_by(id: tweet_id)
    if tweet
      # 删除可能会失败
      Tweet.delete_all('id = ?', tweet_id)
      Comment.delete_all('tweet_id = ?', tweet_id)
    else
      false
    end
  end

  # TODO 获取推荐内容,返回两条
  def Tweet.get_recommend_tweets(user_id)
    []
  end
end
