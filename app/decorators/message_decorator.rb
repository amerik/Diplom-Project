# coding: utf-8
class MessageDecorator < ApplicationDecorator
  delegate_all

  def created_at
  	if DateTime.now.to_date == object.created_at.to_date
  		object.created_at.strftime('Today %H:%M').to_s + " PM"
  	else
  		object.created_at.strftime('%d.%m.%Y, %H:%M').to_s + " PM"
  	end
  end
end
