class SessionsController < ApplicationController
  def new
  end

  def create
    password = params[:password]
    name = params[:name]
    if name ==nil or name ==''
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '名字不能为空'}.to_json}
      end
      return
    end
    if password ==nil or password ==''
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '密码不能为空'}.to_json}
      end
      return
    end
    user = User.find_by(name: name).try(:authenticate, password)
    if user
      session[:current_user] = user
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'success', :info => '成功'}.to_json}
      end
    else
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '用户名或者密码错误'}.to_json}
      end
    end
  end

  def logout
    user = session[:current_user]
    if user
      session[:current_user] = nil
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'success', :info => '成功'}.to_json}
      end
    else
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '你尚未登录'}.to_json}
      end
    end
  end

  def post_tweet
    if params[:content] == nil or params[:content] == ''
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '文本内容为空'}.to_json}
      end
      return
    end
    user = session[:current_user]
    if user == nil
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '请先登录'}.to_json}
      end
    else
      t = Tweet.add_tweet(user['id'], params[:content])
      if t
        respond_to do |format|
          format.js
          format.html
          format.json {render :json => {:status => 'success', :info => '成功'}.to_json}
        end
      else
        respond_to do |format|
          format.js
          format.html
          format.json {render :json => {:status => 'error', :info => '失败'}.to_json}
        end
      end
    end
  end

  def post_comment
    tweet_id = params[:tweet_id]
    comment = params[:comment]
    if comment ==nil or comment ==''
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '评论为空'}.to_json}
      end
      return
    end
    user = session[:current_user]
    if user == nil
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '请先登录'}.to_json}
      end
      return
    end
    tweet = Tweet.find_by(id: tweet_id)
    unless tweet
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '原动态已不存在'}.to_json}
      end
      return
    end
    comment = Comment.post_comment(comment, user['id'], tweet)
    if comment
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'success', :info => '成功', :id => comment[:id], :tweet_id => tweet[:id], :num => tweet[:comment_num]}.to_json}
      end
    else
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '保存comment失败'}.to_json}
      end
    end
  end

  def reply_top_comment
    tweet_id = params[:tweet_id]
    comment = params[:comment]
    top_comment_id = params[:top_comment_id]
    if comment ==nil or comment ==''
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '评论为空'}.to_json}
      end
      return
    end
    user = session[:current_user]
    if user == nil
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '请先登录'}.to_json}
      end
      return
    end
    tweet = Tweet.find_by(id: tweet_id)
    unless tweet
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '原动态已不存在'}.to_json}
      end
      return
    end
    top_comment = Comment.find_by(id: top_comment_id)
    unless top_comment
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '原评论已不存在'}.to_json}
      end
      return
    end
    comment = Comment.reply_top_comment(comment, user['id'], tweet, top_comment)
    if comment
      reply_user = User.find_by(id: top_comment[:user_id])
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'success', :info => '成功', :reply_user_name => reply_user[:name], :top_comment_reply_num => top_comment[:replyed_num], :new_comment_id => comment[:id], :tweet_comment_num => tweet[:comment_num]}.to_json}
      end
    else
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '保存comment失败'}.to_json}
      end
    end
  end

  def thumbsup_comment
    comment_id = params[:comment_id]
    comment = Comment.find_by(id: comment_id)
    user = session[:current_user]
    if user == nil
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '请先登录'}.to_json}
      end
      return
    end
    unless comment
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '原评论已不存在'}.to_json}
      end
      return
    end
    s, code= CommentThumbsUp.thumbs_up(user['id'], comment)
    if s
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'success', :info => '成功', :num => comment[:thumbs_up_num]}.to_json}
      end
    else
      if code == 0
        respond_to do |format|
          format.js
          format.html
          format.json {render :json => {:status => 'error', :info => '点赞失败'}.to_json}
        end
      else
        respond_to do |format|
          format.js
          format.html
          format.json {render :json => {:status => 'error', :info => '已经点过赞了'}.to_json}
        end
      end
    end
  end

  def add_tag
    user = session[:current_user]
    unless user
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '请先登录'}.to_json}
      end
      return
    end
    newtag = params[:newtag]
    if newtag == nil or newtag == ''
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '标签为空'}.to_json}
      end
      return
    end
    tweet_id = params[:tweet_id]
    tweet = Tweet.find_by(id: tweet_id)
    if tweet == nil
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '找不到原动态'}.to_json}
      end
      return
    end
    if tweet[:user_id] != user['id']
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '这不是你发表的动态,你不能添加标签'}.to_json}
      end
      return
    end
    e_tags = TweetTag.list_tags(tweet[:id])
    if e_tags.length >= 8
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '标签不能多于八个'}.to_json}
      end
      return
    end
    tweet_tag = TweetTag.add_tweet_tag(newtag, tweet)
    if tweet_tag
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'success', :info => '成功', :id => tweet_tag[:id], :tag => tweet_tag[:tag]}.to_json}
      end
    else
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '添加失败'}.to_json}
      end
    end
  end

  def delete_tweet
    tweet_id = params[:tweet_id]
    tweet = Tweet.find_by(id: tweet_id)
    unless tweet
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '原动态已不存在'}.to_json}
      end
      return
    end
    user = session[:current_user]
    unless user
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '请先登录'}.to_json}
      end
      return
    end
    if tweet[:user_id]!=user['id']
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '这不是你发表的动态,你没有权限删除'}.to_json}
      end
      return
    end
    if Tweet.delete_tweet(tweet_id)
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'success', :info => '删除成功'}.to_json}
      end
    else
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '删除失败'}.to_json}
      end
    end
  end

  def delete_tag
    tag_id = params[:tag_id]
    tag = TweetTag.find_by(id: tag_id)
    unless tag
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '标签已不存在'}.to_json}
      end
      return
    end
    user = session[:current_user]
    unless user
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '请先登录'}.to_json}
      end
      return
    end
    tweet = Tweet.find_by(id: tag[:tweet_id])
    unless tweet
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '原动态已不存在'}.to_json}
      end
      return
    end
    if user['id'] != tweet[:user_id]
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '这不是你发表的动态,你不能删除其标签'}.to_json}
      end
      return
    end
    if TweetTag.delete_tweet_tag(tag_id, tweet)
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'success', :info => '成功'}.to_json}
      end
    else
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '删除失败'}.to_json}
      end
    end
  end

  def unthumbsup_comment
    comment_id = params[:comment_id]
    comment = Comment.find_by(id: comment_id)
    user = session[:current_user]
    unless comment
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '原评论已不存在'}.to_json}
      end
      return
    end
    if user == nil
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '请先登录'}.to_json}
      end
      return
    end
    s, code= CommentThumbsUp.un_thumbs_up(user['id'], comment)
    if s
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'success', :info => '成功', :num => comment[:thumbs_up_num]}.to_json}
      end
    else
      if code == 0
        respond_to do |format|
          format.js
          format.html
          format.json {render :json => {:status => 'error', :info => '取消点赞失败'}.to_json}
        end
      else
        respond_to do |format|
          format.js
          format.html
          format.json {render :json => {:status => 'error', :info => '还没有赞过,不能取消点赞'}.to_json}
        end
      end
    end
  end

  def thumbsup
    tweet_id = params[:tweet_id]
    tweet = Tweet.find_by(id: tweet_id)
    user = session[:current_user]
    unless tweet
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '原动态已不存在'}.to_json}
      end
      return
    end
    if user == nil
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '请先登录'}.to_json}
      end
      return
    end
    s, code= TweetThumbsUp.thumbs_up(user['id'], tweet)
    if s
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'success', :info => '成功', :num => tweet[:thumbs_up_num]}.to_json}
      end
    else
      if code == 0
        respond_to do |format|
          format.js
          format.html
          format.json {render :json => {:status => 'error', :info => '点赞失败'}.to_json}
        end
      else
        respond_to do |format|
          format.js
          format.html
          format.json {render :json => {:status => 'error', :info => '已经点过赞了'}.to_json}
        end
      end
    end
  end

  def unthumbsup
    tweet_id = params[:tweet_id]
    tweet = Tweet.find_by(id: tweet_id)
    user = session[:current_user]
    unless tweet
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '原动态已不存在'}.to_json}
      end
      return
    end
    if user == nil
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '请先登录'}.to_json}
      end
      return
    end
    s, code= TweetThumbsUp.un_thumbs_up(user['id'], tweet)
    if s
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'success', :info => '成功', :num => tweet[:thumbs_up_num]}.to_json}
      end
    else
      if code == 0
        respond_to do |format|
          format.js
          format.html
          format.json {render :json => {:status => 'error', :info => '取消点赞失败'}.to_json}
        end
      else
        respond_to do |format|
          format.js
          format.html
          format.json {render :json => {:status => 'error', :info => '还没有赞过,不能取消点赞'}.to_json}
        end
      end
    end
  end

  def transmit
    tweet_id = params[:tweet_id]
    content = params[:content]
    user = session[:current_user]
    tweet = Tweet.find_by(id: tweet_id)
    unless tweet
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '原动态已不存在'}.to_json}
      end
      return
    end
    if user == nil
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '请先登录'}.to_json}
      end
      return
    end
    new_tweet = Tweet.transmit_tweet(tweet, content, user['id'])
    if new_tweet
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'success', :info => '成功'}.to_json}
      end
    else
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '转发失败'}.to_json}
      end
    end
  end

  def reply_comment
    tweet_id = params[:tweet_id]
    comment = params[:comment]
    top_comment_id = params[:top_comment_id]
    reply_comment_id = params[:reply_comment_id]
    if comment ==nil or comment ==''
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '评论为空'}.to_json}
      end
      return
    end
    user = session[:current_user]
    tweet = Tweet.find_by(id: tweet_id)
    unless tweet
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '原动态已不存在'}.to_json}
      end
      return
    end
    if user == nil
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '请先登录'}.to_json}
      end
      return
    end
    top_comment = Comment.find_by(id: top_comment_id)
    unless top_comment
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '原评论已不存在'}.to_json}
      end
      return
    end
    reply_comment = Comment.find_by(id: reply_comment_id)
    unless reply_comment
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '原评论已不存在'}.to_json}
      end
      return
    end
    comment = Comment.reply_comment(comment, user['id'], tweet, top_comment, reply_comment)
    if comment
      reply_user = User.find_by(id: reply_comment[:user_id])
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'success', :info => '成功', :reply_user_name => reply_user[:name], :reply_comment_reply_num => reply_comment[:replyed_num], :top_comment_reply_num => top_comment[:replyed_num], :new_comment_id => comment[:id], :tweet_comment_num => tweet[:comment_num]}.to_json}
      end
    else
      respond_to do |format|
        format.js
        format.html
        format.json {render :json => {:status => 'error', :info => '保存comment失败'}.to_json}
      end
    end
  end

end
