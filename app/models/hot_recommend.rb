class HotRecommend < ActiveRecord::Base
  # 通过热度进行推荐 历史转发数量*最近五天点赞数量
  def HotRecommend.task
    now = Time.now
    now = now - 5 * 60 * 60 * 24
    hash = TweetThumbsUp.where('created_at > ?', now.strftime('%Y-%m-%d %H:%M:%S')).group(:tweet_id).count
    max_tweet_hot = 0
    tweet_id = 0
    hash.each do |(key, value)|
      t = Tweet.find_by(id: key)
      if t
        v = (value>0 ? value : 1) * (t[:transmit_num]>0 ? t[:transmit_num] : 1)
        if v> max_tweet_hot
          max_tweet_hot=v
          tweet_id=key
        end
      end
    end
    HotRecommend.delete_all([])
    hr = HotRecommend.new
    hr[:tweet_id] = tweet_id
    hr.save
  end
end
