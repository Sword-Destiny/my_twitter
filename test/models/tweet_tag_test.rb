require 'minitest/autorun'

require './tweet_tag'
require './tweet'
require 'test_helper'
# test of model/tweet_tag.rb
#test of model/tweet_tag.rb
#test of model/tweet_tag.rb

class Tweet_TagTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test ".add_tweet_tag(tag, tweet) should be valid" do
     tweet_tag = TweetTag.new
     tweet = Tweet.new
     tweet_tag.add_tweet_tag("happy",tweet)
     assert_equal "happy" , tweet_tag[:tag]
     assert_equal tweet[:id] ,tweet_tag[:tweet_id]
    
  end
  
end
