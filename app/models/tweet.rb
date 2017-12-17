class Tweet < ActiveRecord::Base
  def Tweet.list_tweets(user_id)
    if user_id!=-1
      my_tweets = Tweet.where('user_id = ?', user_id)
      follow_tweets = Tweet.where('user_id in (select id from follows where follower_id = ?)', user_id)
      user_tweets = my_tweets + follow_tweets
      user_tweets.sort_by! {|t| t[:created_at]}
      user_tweets.reverse!
      recommend_tweets = Tweet.get_recommend_tweets(user_id)
      tweets = user_tweets[0...8] + recommend_tweets
      tweets
    else
      Tweet.get_recommend_tweets(user_id)
    end

  end

  def Tweet.add_tweet(user_id, contents)
    tweet = Tweet.new
    tweet[:user_id] = user_id
    tweet[:contents] = contents
    tweet[:thumbs_up_num] = 0
    tweet[:transmit_num] = 0
    tweet[:transmit_from_id] = -1
    if tweet.save
      tweet
    else
      nil
    end
  end

  # TODO 获取推荐内容,返回两条
  def Tweet.get_recommend_tweets(user_id)
    []
  end
end
