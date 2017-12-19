class ImInfo < ActiveRecord::Base

  def ImInfo.send_im_info(sender_id, receiver_id, contents)
    im_info = ImInfo.new
    im_info[:from] = sender_id
    im_info[:to] = receiver_id
    im_info[:info] = contents
    im_info[:read] = 0
    im_info.save
  end

  def ImInfo.read_all_im_info(sender_id, receiver_id)
    ImInfo.update_all('read = 1', 'to = ? and from = ?', receiver_id, sender_id)
  end

  def ImInfo.list_all_unread_im_info(sender_id)
    ImInfo.where('to = ? and read = 0', sender_id)
  end
end
