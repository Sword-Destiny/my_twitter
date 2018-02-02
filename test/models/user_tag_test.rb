require 'minitest/autorun'

require './user_tag'
require 'test_helper'
# test of model/user_tag.rb
#test of model/user_tag.rb
#test of model/user_tag.rb

class UserTagTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test ".add_user_tag(tag, user) should be valid" do
    user_tag = UserTag.new
    user = User.new
    
    user_tag.add_user_tag("happy",user)
    assert_equal "happy",  user_tag[:tag]
    assert_equal user[:id],user_tag[:user_id]
  end
end
