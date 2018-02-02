require 'minitest/autorun'

require './tweet_thumbs_up'
require "./tweet"
require 'test_helper'
# test of model/tweet_thumbs_up.rb
#test of model/tweet_thumbs_up.rb
#test of model/tweet_thumbs_up.rb

class TweetThumbsUpTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "thumbs_up(user_id, tweet) should be valid" do
    thumbs_up = TweetThumbsUp.new
    tweet = Tweet.new
    thumbs_up(11,tweet)
    assert_equal 11,thumbs_up[:user_id]
    assert_equal tweet[:id],thumbs_up[:tweet_id]
  end
end
