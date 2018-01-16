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
