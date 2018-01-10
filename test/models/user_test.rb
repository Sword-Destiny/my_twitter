require 'test_helper'
require 'user.rb'

class UserTest < ActiveSupport::TestCase
  test "user attributes must not be empty" do  
    user = User.new  
    assert user.invalid?
  end
end
