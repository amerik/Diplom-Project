# coding: utf-8
class PageHelpDecorator < ApplicationDecorator
	decorates_association :page_help
  delegate_all


  def description
  	field_string(object.description)
  end   

  def name_for_select
    object.name
  end
end
