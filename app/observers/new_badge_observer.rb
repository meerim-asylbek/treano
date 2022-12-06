class NewBadgeObserver
  def update(changed_data)
    return unless changed_data[:merit_object].is_a?(Merit::BadgesSash)

    user = User.where(sash_id: changed_data[:sash_id]).first
    badge = changed_data[:merit_object]
    granted_at = changed_data[:granted_at]

    noti = BadgeNotification.with(user: user, badge: badge, granted_at: granted_at)
    noti.deliver(user)

    #BadgeMailer.earned_badge(user, badge, granted_at).deliver_later
  end
end
