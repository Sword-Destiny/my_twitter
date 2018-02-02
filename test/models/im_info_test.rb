#vim 
require 'minitest/autorun'
require './im_info'
require test_helper
# test of model/im_info.rb
#test of model/im_info.rb
#test of model/im_info.rb
class TestImInfo < ActiveSupport::TestCase
  
  # test "the truth" do
  #   assert true
  # end
  def setup
    @imfo = ImInfo.new
    
  end
  
  test "info should be valid" do
    assert @info.valid?
  end
  
  test "send_im_info should be valid " do
    @info = ImInfo.send_im_info(11,12,"hello,Bai!")
    assert_equal 11 , @info[:from]
    assert_equal 12 , @info[:to]
    assert_equal "hello,Bai" , @info[:info]
    assert_equal 0 , @info[:read]
  end
  
  test "read_im_info should be valid" do
    @info = ImInfo.send_im_info(11,12,"hello,Bai!")
    info[:to] = 12
    info =@info.find_by(id: 1)
      unless info
       assert false
      end
      user = User.find_by(id: info[:to])
      unless user
      assert false
      end
  end
  
  test "read_all_im_info should be valid" do
    @info = ImInfo.send_im_info(11,12,"hello,Bai!")
    receiver = User.find_by(id: 12)
    unless receiver
      assert false
    end
  end
end
