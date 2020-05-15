class NotificationDecorator < ApplicationDecorator
  delegate_all

  def created_at_time
    time_at(object.created_at)
  end


end
