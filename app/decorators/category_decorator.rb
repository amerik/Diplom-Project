# coding: utf-8
class CategoryDecorator < ApplicationDecorator
	decorates_association :category	
  delegate_all

  def name_for_select
    object.name
  end
end
