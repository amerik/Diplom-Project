# coding: utf-8
class UserAchivmentDecorator < ApplicationDecorator
	decorates_association :user_achivment
  delegate_all

  def description
    field_string(object.description)
  end

  def task
    unless object.task.nil?
    	status_this = I18n.t("model.task.status.#{object.task.status}")
    	"#{object.task.description}, <b>#{status_this}</b>".html_safe
    else
    	"-"
    end
  end
end
