class TagRecommend < ActiveRecord::Base
  # 通过标签进行推荐
  def TagRecommend.task
    TagRecommend.delete_all([])
    usertags = UserTag.select('distinct user_id')
    usertags.each do |user_tag|
      tweet_tags = TweetTag.where('tag in (select tag from user_tags where user_id = ?)', user_tag[:user_id])
      tweet_count = tweet_tags.group(:tweet_id).count
      tweet_id = -1
      max_count_tweet_id = 0
      tweet_count.each do |(key,value)|
        if value > max_count_tweet_id
          max_count_tweet_id = value
          tweet_id = key
        end
      end
      tr = TagRecommend.find_by(user_id: user_tag[:user_id])
      if tr
        tr.update_attribute(:tweet_id, tweet_id)
      else
        tr = TagRecommend.new
        tr[:tweet_id] = tweet_id
        tr[:user_id] = user_tag[:user_id]
        tr.save
      end
    end
  end
end
