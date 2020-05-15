# coding: utf-8
class BasketDecorator < ApplicationDecorator
	decorates_association :basket
  delegate_all
end
