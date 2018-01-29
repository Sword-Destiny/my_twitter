#vim people_test.rb
require 'minitest/autorun'
require './user'
require test_help

class TestUser < ActiveSupport::TestCase
  def setup
    @user = User.new(name:"bai", password:"123456")
  end

  test "should be valid" do
    assert @user.valid?
  end
  
  test "user's name should be present" do
    @user.name='    '
    assert_not @user.valid?
  end
end