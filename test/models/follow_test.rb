require 'minitest/autorun'
require './follow'

require 'test_helper'
# test of model/follow.rb
#test of model/follow.rb
#test of model/followp.rb

class FollowTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "add_follow should be valid" do
    follow = Follow.new
    follow.add_follow(11,12)
    assert_equal 11 ,follow[:user_id]

    assert_equal 12,follow[:follower_id]
    
  end
end
