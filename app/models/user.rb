class User < ActiveRecord::Base
  has_secure_password

  def User.register(user_params)
    user = User.create(user_params)
    user[:unread_info_num] = 0
    user[:head_picture] = '/heads/default.png'
    if user.save
      # 增加一条私信，从系统发送给新用户
      im_info = ImInfo.send_im_info(1, user[:id], 'Wellcome to our website!')
      if im_info
        user.update_attribute(:unread_info_num, 1)
      end
      user
    else
      nil
    end
  end

  def User.update_head_picture(user_id, file, name)
    new_url = process_head_picture(file, user_id, name)
    user = User.find_by(id: user_id)
    unless user
      return false, new_url #用户不存在
    end
    r = user.update_attributes(:head_picture => new_url)
    return r, new_url
  end

  def User.process_head_picture(file, user_id, name)
    dir_path = "#{Rails.root}/public"
    file_ext = name[/\.[^.]+$/]
    store_path = "/heads/#{user_id}-#{Digest::MD5.hexdigest(Time.now.to_s)}#{file_ext}"
    file_path = "#{dir_path}#{store_path}"
    File.open(file_path, 'wb+') do |item| # 用二进制对文件进行写入
      item.write(file)
    end
    img = MiniMagick::Image.open(file_path) # 通过路径打开图片
    w, h = img[:width], img[:height] # 获得图片的宽和高
    shaved_off = w >= h ? [((w-h)/2).round, 0] : [0, ((h-w)/2).round] # 判断宽高，将长的一部分左右各裁一半
    img.shave "#{shaved_off[0]}x#{shaved_off[1]}" # shave 裁剪函数
    img.resize 100 # 图片按100的尺寸缩放
    img.write(file_path) # 按原路径保存

    return store_path
  end

  def User.update_name(user_id, name)
    user = User.find_by(id: user_id)
    unless user
      false #用户不存在
    end
    user.update_attributes(:name => name)
  end

  def User.update_password(user, password)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    password_digest = BCrypt::Password.create(password, cost: cost)
    user.update_attributes(:password_digest => password_digest)
  end

  def User.get_user(user_id)
    User.find_by(id: user_id)
  end

  def User.search_user_name_id(keyword)
    User.where('name like "%?%" or id = ?', keyword, keyword)
  end

  def User.search_user_tag(keyword)
    User.where('id in ( select user_id from user_tags where tag = ? )', keyword)
  end

  def User.search(keyword)
    # TODO
  end

  def User.gen_tags_by_tweet(user_id)
    # TODO
  end

  def User.gen_tags_by_comments(user_id)
    # TODO
  end

end
