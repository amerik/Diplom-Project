# coding: utf-8
class NoteDecorator < ApplicationDecorator
	decorates_association :note
  delegate_all

  def name
  	field_string(object.name)
  end

  def description
  	field_string(object.description)
  end

  def created_at
  	datetime_at(object.created_at)
  end
end
