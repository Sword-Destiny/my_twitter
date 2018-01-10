require File.dirname(__FILE__) + '/../test_helper'
require 'test_helper'
class ApplicantsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
    print "right"
  end

  test "should get create" do
    get :create
    assert_response :success
  end

end
