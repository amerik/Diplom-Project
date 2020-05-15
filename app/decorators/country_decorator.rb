# coding: utf-8
class CountryDecorator < ApplicationDecorator
	decorates_association :country
  delegate_all

  def name_for_select
  	object.name_en
  end
end
