require 'test_helper'

class PersonalHomepageControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get update_head_picture" do
    get :update_head_picture
    assert_response :success
  end

  test "should get send_im_info" do
    get :send_im_info
    assert_response :success
  end

  test "should get read_im_info" do
    get :read_im_info
    assert_response :success
  end

  test "should get add_tag" do
    get :add_tag
    assert_response :success
  end

  test "should get delete_tag" do
    get :delete_tag
    assert_response :success
  end

  test "should get update_name" do
    get :update_name
    assert_response :success
  end

  test "should get update_password" do
    get :update_password
    assert_response :success
  end

  test "should get follow" do
    get :follow
    assert_response :success
  end

  test "should get unfollow" do
    get :unfollow
    assert_response :success
  end

end
