# coding: utf-8
class AchivmentDecorator < ApplicationDecorator
  decorates_association :achivment	
  delegate_all

  def name_for_select
    object.name
  end
end
