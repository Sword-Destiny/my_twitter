#vim 
require 'minitest/autorun'
require './comment'
require './tweet'
require 'test_helper'
# test of model/comment.rb
#test of model/comment.rb
#test of model/comment.rb
class CommentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @comment = Comment.new
    @tweet = Tweet.new
  end
  test "post_comment(contents, user_id, tweet) should be valid" do
    @comment.post_comment("great",11,@tweet)
    assert_equal "great",@comment[:contents]
    assert_equal 0, @comment[:thumbs_up_num]
    assert_equal 0,  @comment[:replyed_num]
    assert_equal -1, @comment[:top_comment_id]
    assert_equal -1,  @comment[:reply_comment_id]
    assert_equal 11, @comment[:user_id]

  end
  
  test "is_top_comment() should be valid" do
    @comment[:top_comment_id]=-1
    assert_equal true ,@comment.is_top_comment(@comment)
  end
  
  test "reply_top_comment should be valid" do
    @comment.reply_comment("hello",11,@tweet,top_comment)
    assert_equal "hello", @comment[:contents]
    assert_equal 11,@comment[:user_id]
    
  end
  

end
