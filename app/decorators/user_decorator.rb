# coding: utf-8
class UserDecorator < ApplicationDecorator
  decorates_association :user
  delegate_all

  def updated_at
    datetime_at(object.updated_at)
  end

  def online_at
    datetime_at(object.online_at)
  end

  def created_at
    date_at(object.created_at)
  end

  def login
    "[#{object.id}] #{object.login}"
  end

  def login_header
    if object.profile.first_name != "" && !object.profile.first_name.nil?
      object.profile.first_name
    else
      object.login
    end
  end

  def name_for_select
    login
  end

  def is_mentor_verification
    if object.is_mentor_verification
      "Да"
    else
      "Нет"
    end
  end

  def price
    field_currency_float(object.price, 0)
  end

  def price_full
    field_currency_float(object.price_full, 0)
  end

  def price_total
    field_currency_float(object.price_total, 0)
  end
end
