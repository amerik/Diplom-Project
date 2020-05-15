# coding: utf-8
class ProfileDecorator < ApplicationDecorator
  decorates_association :profile
  delegate_all

  include ActionView::Helpers::NumberHelper

	def full_name
    if (object.last_name != "" && !object.last_name.nil?) || (object.first_name != "" && !object.first_name.nil?)
      "#{object.last_name} #{object.first_name}"
    else
      object.user.login
    end
  end

  def last_name
    field_string(object.last_name)
  end

  def first_name
    field_string(object.first_name)
  end

  def about_me
    field_string(object.about_me)
  end

  def email
    field_string(object.email, "-")
  end

  def initials
  	first_name = ""
  	first_name = "#{object.first_name.mb_chars.upcase.first.to_s}." unless object.first_name.nil?
    "#{first_name}"
  end

  def last_name_with_initials
  	"#{object.last_name} #{initials}"
  end

  def birth_at
    date_at(object.birth_at)
  end

  def time_zone
    if object.time_zone.to_i > 0
      "+#{object.time_zone.to_i}GMT"
    else
      "#{object.time_zone.to_i}GMT"
    end
  end

  def city
    unless object.city.nil?
      field_string(object.city.name)
    else
      "-"
    end
  end

  def location
    unless object.city.nil?
      "#{field_string(object.city.country.name_en)}, #{field_string(object.city.name_en)}"
    else
      "-"
    end
  end

  def university
    unless object.university.nil?
      object.university.name
    else
      "-"
    end
  end

  def specialization
    if object.specializations.count > 0
      sp = object.specializations.or_default.first
      "#{sp.name}, #{sp.company}"
    else
      "-"
    end
  end

  def about_my
    field_string(object.about_my)
  end

  def sex
    I18n.t("model.profile.sex.#{object.sex}")
  end

  def time_preference
    unless object.time_preference.nil?
      I18n.t("model.profile.time_preference.#{object.time_preference}")
    else
      "-"
    end
  end

  def price_preference
    unless object.price_preference.nil?
      I18n.t("model.profile.price_preference.#{object.price_preference}")
    else
      "-"
    end
  end
end
