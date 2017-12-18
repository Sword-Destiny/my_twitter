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
end
