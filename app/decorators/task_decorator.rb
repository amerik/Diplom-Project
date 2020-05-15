# coding: utf-8
class TaskDecorator < ApplicationDecorator
	decorates_association :task
  delegate_all

  def status
  	I18n.t("model.task.status.#{object.status}")
  end

  def description
  	field_string(object.description)
  end
end
