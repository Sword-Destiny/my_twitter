#vim 
require 'minitest/autorun'
require './user'
require test_helper
# test of model/user.rb
#test of model/user.rb
#test of model/user.rb
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
  
  test "name should not be too long" do
    @user.name = aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
    assert_not @user.valid?
  end
  
  test "user should have picture" do
    @user = User.register('bai',123456)
    assert_equal '/heads/default.png',  @user[:head_picture]
  end
  
  test "user should have the default message from " do
    assert_equal 'Wellcome to our website!', @user.im_info[1]
  end
  
  test "name should be update if change the name" do
    @user.update_name(11,'bai1')
    assert_equal 'bai1', @user.name
    
  end
  
  test "password should be update if change the password" do
    @user.update_password(self,'1234567')
    assert_equal '1234567',@user.password
  end
  

end