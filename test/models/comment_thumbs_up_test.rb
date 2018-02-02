require 'minitest/autorun'
require './comment_thumbs_up'
require './comment'
require 'test_helper'
# test of model/comment_thumbs_up.rb
#test of model/comment_thumbs_up.rb
#test of model/comment_thumbs_up.rb

class CommentThumbsUpTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test " thumbs_up() should be valid" do
     thumbs_up = CommentThumbsUp.new
     comment = Comment.new
     thumbs_up.thumbs_up(11,comment)
     
     assert_equal 11,thumbs_up[:user_id]
     assert_equal comment[:id],thumbs_up[:comment_id]
    
  end
end
