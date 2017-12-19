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

  def User.update_head_picture(user_id, url)
    user = User.find_by(id: user_id)
    unless user
      false #用户不存在
    end
    user.update_attributes(:head_picture => url)
  end

  def User.update_name(user_id, name)
    user = User.find_by(id: user_id)
    unless user
      false #用户不存在
    end
    user.update_attributes(:name => name)
  end

  def User.update_password(user_id, password)
    user = User.find_by(id: user_id)
    unless user
      false #用户不存在
    end
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    password_digest = BCrypt::Password.create(password, cost: cost)
    user.update_attributes(:password_digest => password_digest)
  end

end
