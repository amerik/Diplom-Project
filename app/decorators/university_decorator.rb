# coding: utf-8
class UniversityDecorator < ApplicationDecorator
	decorates_association :university
  delegate_all

  def name
  	field_string(object.name)
  end

  def position
  	field_int(object.position)
  end

  def name_for_select
  	field_string(object.name)
  end
end
