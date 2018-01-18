class ImInfo < ActiveRecord::Base

  def ImInfo.send_im_info(sender_id, receiver_id, contents)
    im_info = ImInfo.new
    im_info[:from] = sender_id
    im_info[:to] = receiver_id
    im_info[:info] = contents
    im_info[:read] = 0
    im_info.save
  end

  def ImInfo.read_all_im_info(receiver_id)
    receiver = User.find_by(id: receiver_id)
    unless receiver
      false
    end
    if ImInfo.where('"to" = ?', receiver_id).update_all('read = 1')
      receiver.update_attribute(:unread_info_num, 0)
    end
  end

  def ImInfo.read_im_info(info_id)
    info =ImInfo.find_by(id: info_id)
    unless info
      false
    end
    user = User.find_by(id: info[:to])
    unless user
      false
    end
    if info.update_attribute(:read, 1)
      user.update_attribute(:unread_info_num, user[:unread_info_num]-1)
    end
  end

  def ImInfo.list_all_unread_im_info(receiver_id)
    infos = ImInfo.where('"to" = ? and read = 0', receiver_id).order('"from"')
    im_infos = []
    if infos.length>0
      from = infos[0][:from]
      fuser = User.find_by(id: from)
      im_infos.push({:from => from, :username => fuser[:name], :picture => fuser[:head_picture], :im => []})
      infos.each do |info|
        if info[:from] == from
          im_infos.last[:im].push(info)
        else
          from = info[:from]
          fuser = User.find_by(id: from)
          im_infos.push({:from => from, :username => fuser[:name], :picture => fuser[:head_picture], :im => []})
        end
      end
    end
    {:num => infos.length, :ims => im_infos}
  end
end
