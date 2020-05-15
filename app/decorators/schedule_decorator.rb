# coding: utf-8
class ScheduleDecorator < ApplicationDecorator
	decorates_association :schedule
  delegate_all

  def period_time
  	if object.kind == 'hour_1'
  		end_at = object.start_at + 1.hours
  	else
  		end_at = object.start_at + 1.hours
  	end
  	"#{time_at(object.start_at)} - #{time_at(end_at)}"
  end

  def date_day
  	date_at(object.start_at)
  end

  def date_day_with_time
    date = object.start_at.strftime('%B - %d, %Y')
    "#{date} (#{period_time})"
  end

  def student
  	unless object.user.nil?
  		object.user.profile.decorate.full_name
  	else
  		"-"
  	end
  end
end
