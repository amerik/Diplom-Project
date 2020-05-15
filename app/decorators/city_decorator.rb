# coding: utf-8
class CityDecorator < ApplicationDecorator
	decorates_association :city
  delegate_all

  def country
  	unless object.country.nil?
  		object.country.name_en + " / " + object.country.name_rus
  	else
  		"-"
  	end
  end

  def name_for_select
  	object.name_en
  end
end
