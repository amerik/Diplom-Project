# coding: utf-8
class RoleDecorator < ApplicationDecorator
  decorates_association :profile
  delegate_all

  def name_for_select
  	object.name
  end
end
