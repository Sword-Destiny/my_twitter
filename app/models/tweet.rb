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
      process_tweets(user_tweets, recommend_tweets, user_id)
    else
      Tweet.get_recommend_tweets(user_id)
    end
  end

  def Tweet.process_tweets(tweets, recommends, user_id)
    tweets_list = []
    tweets.each do |tweet|
      thumbsup = TweetThumbsUp.find_thumbs_up(user_id, tweet[:id])
      user = User.find_by(id: tweet[:user_id])
      tags = TweetTag.list_tags(tweet[:id])
      if tweet[:transmit_from_id] == -1 or tweet[:transmit_from_id] == '-1'
        tweets_list.push({:tags => tags, :username => user[:name], :tweet => tweet, :transmit_name => '', :thumbsup => thumbsup})
      else
        transmit_tweet = Tweet.find_by(id: tweet[:transmit_from_id])
        transmit_name = User.find_by(id: transmit_tweet[:user_id])[:name]
        tweets_list.push({:username => user[:name], :tweet => tweet, :transmit_name => transmit_name, :thumbsup => thumbsup, :transmit_tweet => transmit_tweet})
      end
    end
    tweets_list
  end

  def Tweet.transmit_tweet(old_tweet, contents, user_id)
    tweet = Tweet.new
    tweet[:user_id] = user_id
    tweet[:contents] = contents
    tweet[:thumbs_up_num] = 0
    tweet[:transmit_num] = 0
    if old_tweet[:transmit_from_id]==-1 or old_tweet[:transmit_from_id]=='-1'
      tweet[:transmit_from_id] = old_tweet[:id]
    else
      tweet[:transmit_from_id] = old_tweet[:transmit_from_id]
    end
    tweet[:comment_num] = 0
    if tweet.save
      if old_tweet[:transmit_from_id]==-1 or old_tweet[:transmit_from_id]=='-1'
        old_tweet.update_attribute(:transmit_num, old_tweet[:transmit_num]+1)
      else
        top_tweet = Tweet.find_by(id: old_tweet[:transmit_from_id])
        top_tweet.update_attribute(:transmit_num, top_tweet[:transmit_num]+1)
      end
      tweet
    else
      nil
    end
  end

  # 搜索tweet
  def Tweet.search_tweet(user_id, keyword)
    search_tweets = []+Tweet.where('contents like "%'+keyword+'%"')
    search_tweets.sort_by! {|t| t[:created_at]}.reverse!
    recommends = get_recommend_tweets(user_id)
    process_tweets(search_tweets, recommends, user_id)
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
