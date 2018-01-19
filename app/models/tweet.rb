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
      process_tweets([], Tweet.get_recommend_tweets(user_id), user_id)
    end
  end

  def Tweet.process_tweets(tweets, recommends, user_id)
    tweets_list = []
    recommends.each do |tweet|
      thumbsup = TweetThumbsUp.find_thumbs_up(user_id, tweet[:id])
      user = User.find_by(id: tweet[:user_id])
      tags = TweetTag.list_tags(tweet[:id])
      if tweet[:transmit_from_id] == -1 or tweet[:transmit_from_id] == '-1'
        tweets_list.push({:type => 'tweet', :recommend => true, :tags => tags, :username => user[:name], :tweet => tweet, :transmit_name => '', :thumbsup => thumbsup})
      else
        transmit_tweet = Tweet.find_by(id: tweet[:transmit_from_id])
        if transmit_tweet
          transmit_name = User.find_by(id: transmit_tweet[:user_id])[:name]
          tweets_list.push({:type => 'tweet', :recommend => true, :username => user[:name], :tweet => tweet, :transmit_name => transmit_name, :thumbsup => thumbsup, :transmit_tweet => transmit_tweet})
        else
          transmit_name = '已删除'
          tweets_list.push({:type => 'tweet', :recommend => true, :username => user[:name], :tweet => tweet, :transmit_name => transmit_name, :thumbsup => thumbsup, :transmit_tweet => transmit_tweet})
        end
      end
    end
    tweets.each do |tweet|
      thumbsup = TweetThumbsUp.find_thumbs_up(user_id, tweet[:id])
      user = User.find_by(id: tweet[:user_id])
      tags = TweetTag.list_tags(tweet[:id])
      if tweet[:transmit_from_id] == -1 or tweet[:transmit_from_id] == '-1'
        tweets_list.push({:type => 'tweet', :recommend => false, :tags => tags, :username => user[:name], :tweet => tweet, :transmit_name => '', :thumbsup => thumbsup})
      else
        transmit_tweet = Tweet.find_by(id: tweet[:transmit_from_id])
        if transmit_tweet
          transmit_name = User.find_by(id: transmit_tweet[:user_id])[:name]
          tweets_list.push({:type => 'tweet', :recommend => false, :username => user[:name], :tweet => tweet, :transmit_name => transmit_name, :thumbsup => thumbsup, :transmit_tweet => transmit_tweet})
        else
          transmit_name = '已删除'
          tweets_list.push({:type => 'tweet', :recommend => false, :username => user[:name], :tweet => tweet, :transmit_name => transmit_name, :thumbsup => thumbsup, :transmit_tweet => transmit_tweet})
        end
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
    search_tweets = Tweet.process_tweets(search_tweets, [], user_id)
    search_users = User.process_users(User.search_user(keyword))
    search_users+search_tweets
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
    Tweet.delete_all(['id = ?', tweet_id]) and Comment.delete_all(['tweet_id = ?', tweet_id]) and TweetTag.delete_all(['tweet_id = ?', tweet_id]) and TweetThumbsUp.delete_all(['tweet_id = ?', tweet_id])
  end

  # TODO 获取推荐内容,返回最多两条,去重
  def Tweet.get_recommend_tweets(user_id)
    hr = Tweet.where('id in (select tweet_id from hot_recommends)')
    tr = Tweet.where('id in (select tweet_id from tag_recommends where user_id = ?)', user_id)
    ht = []
    hr.each do |tweet|
      e = false
      ht.each do |exist|
        if tweet[:id] == exist[:id]
          e = true
          break
        end
      end
      unless e
        ht.push(tweet)
      end
    end
    tr.each do |tweet|
      e = false
      ht.each do |exist|
        if tweet[:id] == exist[:id]
          e = true
          break
        end
      end
      unless e
        ht.push(tweet)
      end
    end
    ht
  end
end
