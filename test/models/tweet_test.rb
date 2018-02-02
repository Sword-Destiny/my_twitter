require 'minitest/autorun'

require './tweet'
require 'test_helper'
# test of model/tweet.rb
#test of model/tweet.rb
#test of model/tweet.rb

class TweetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @tweet = Tweet.new
  end
  
  test "add_tweet(user_id, contents) should be valid" do
    @tweet.add_tweet(11,"hello")
    assert_equal 11,tweet[:user_id]
    assert_equal "hello",tweet[:contents] 
    assert_equal 0,tweet[:thumbs_up_num] 
    assert_equal 0, tweet[:transmit_num] 
    assert_equal -1,tweet[:transmit_from_id] 
    assert_equal 0, tweet[:comment_num]
  end
  
  test "transmit_tweet(old_tweet, contents, user_id) should be valid" do
    @tweet.transmit_tweet(@old_tweet,"world",11)
    assert_equal 11,tweet[:user_id]
    assert_equal "world",tweet[:contents] 
    assert_equal 0,tweet[:thumbs_up_num] 
    assert_equal 0,tweet[:transmit_num] 
  end
end
