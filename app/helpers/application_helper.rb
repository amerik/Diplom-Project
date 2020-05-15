# coding: utf-8
module ApplicationHelper
  def meta_title
    if @meta_title.nil?
      "Eleway.com - Find your mentor now"
    else
      @meta_title
    end
  end

  def meta_description
    if @meta_description.nil?
      ""
    else
      @meta_description
    end
  end

  def meta_keywords
    if @meta_keywords.nil?
      ""
    else
      @meta_keywords
    end
  end

  def distance_of_time_in_words(from_time, to_time = 0, include_seconds = false)
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_minutes = (((to_time - from_time).abs)/60).round
    distance_in_seconds = ((to_time - from_time).abs).round
 
    case distance_in_minutes
      when 0..1
        return (distance_in_minutes == 0) ? 'less 1 minute' : '1 minute' unless include_seconds
        case distance_in_seconds
          when 0..4   then 'less 5 seconds'
          when 5..9   then 'less 10 seconds'
          when 10..19 then 'less 20 seconds'
          when 20..39 then 'half a minute'
          when 40..59 then 'less 1 minute'
          else             '1 minute'
        end
 
      when 2..44           then "#{distance_in_minutes} #{min_name(distance_in_minutes)}"
      when 45..89          then 'около 1 hour'
      when 90..1439        then "#{(distance_in_minutes.to_f / 60.0).round} #{hour_name((distance_in_minutes.to_f / 60.0).round)}"
      when 1440..2879      then 'около 1 day'
      when 2880..43199     then "#{(distance_in_minutes / 1440).round} #{day_name((distance_in_minutes / 1440).round)}"
      when 43200..86399    then 'около 1 month'
      when 86400..525599   then "#{(distance_in_minutes / 43200).round} #{month_name((distance_in_minutes / 43200).round)}"
      when 525600..1051199 then 'около 1 year'
      else                      "#{(distance_in_minutes / 525600).round} #{year_name((distance_in_minutes / 525600).round)}"
    end
  end

	def select_enumerize(elements, element_select, name, input_id, i18n, class_li, is_init = true, label_name = 'Select', init_text = '--- Selected ---', cl_button = "")
    ApplicationController.new.render_to_string(partial: 'partials/select_enumerize', 
      locals: {elements: elements, element_select: element_select, is_init: is_init, name: name, input_id: input_id, label_name: label_name, class_li: class_li, init_text: init_text, cl_button: cl_button, i18n: i18n}, 
      layout: false, formats: [:html], handlers: [:haml])
  end

  def select_hours(elements, element_select, name, input_id, class_li, user, is_init = true, label_name = 'Select', is_all = false, init_text = '--- Selected ---', cl_button = "")
    ApplicationController.new.render_to_string(partial: 'partials/select_hours', 
      locals: {elements: elements, element_select: element_select, is_init: is_init, name: name, user: user, input_id: input_id, label_name: label_name, is_all: is_all, class_li: class_li, init_text: init_text, cl_button: cl_button}, 
      layout: false, formats: [:html], handlers: [:haml])
  end

  def download_attachment_path(attach)
    "/attachments/#{attach.id}/download"
  end

 #  def select_enumerize_lk(elements, element_select, name, i18n, class_li, is_init = true, init_text = I18n.t("view.admin.common.select_text"), cl_button = "width-350")
 #    ApplicationController.new.render_to_string(partial: 'partials/select_enumerize_lk', 
 #      locals: {elements: elements, element_select: element_select, is_init: is_init, name: name, class_li: class_li, init_text: init_text, cl_button: cl_button, i18n: i18n}, 
 #      layout: false, formats: [:html], handlers: [:haml])
 #  end

 #  def select_strings(elements, element_select, name, i18n, class_li, is_init = true, init_text = I18n.t("view.admin.common.select_text"), cl_button = "width-350")
 #    ApplicationController.new.render_to_string(partial: 'partials/select_strings', 
 #      locals: {elements: elements, element_select: element_select, is_init: is_init, name: name, class_li: class_li, init_text: init_text, cl_button: cl_button, i18n: i18n}, 
 #      layout: false, formats: [:html], handlers: [:haml])
 #  end

 #  def select_numbers(elements, element_select, name, class_li, is_init = true, init_text = I18n.t("view.admin.common.select_text"), cl_button = "width-350")
 #    ApplicationController.new.render_to_string(partial: 'partials/select_numbers', 
 #      locals: {elements: elements, element_select: element_select, is_init: is_init, name: name, class_li: class_li, init_text: init_text, cl_button: cl_button}, 
 #      layout: false, formats: [:html], handlers: [:haml])
 #  end

  def select_standart(elements, element_select, name, input_id, class_li, is_init = true, label_name = 'Select', init_text = '--- Selected ---', cl_button = "")
    ApplicationController.new.render_to_string(partial: 'partials/select_standart', 
      locals: {elements: elements, element_select: element_select, is_init: is_init, name: name, input_id: input_id, label_name: label_name, class_li: class_li, init_text: init_text, cl_button: cl_button}, 
      layout: false, formats: [:html], handlers: [:haml])
  end


  def select_country(elements, element_select, name, input_id, class_li, is_init = true, label_name = 'Select', init_text = '--- Selected ---', cl_button = "")
    ApplicationController.new.render_to_string(partial: 'partials/select_country', 
      locals: {elements: elements, element_select: element_select, is_init: is_init, name: name, input_id: input_id, label_name: label_name, class_li: class_li, init_text: init_text, cl_button: cl_button}, 
      layout: false, formats: [:html], handlers: [:haml])
  end  

 #  def select_time_zones(element_select, name, class_li, is_init = true, init_text = I18n.t("view.admin.common.select_text"), cl_button = "width-350")
 #  	ApplicationController.new.render_to_string(partial: 'partials/select_time_zones', 
 #      locals: {element_select: element_select.to_i, is_init: is_init, name: name, class_li: class_li, init_text: init_text, cl_button: cl_button}, 
 #      layout: false, formats: [:html], handlers: [:haml])
 #  end

	# def default_checkbox(value, name, value_val, description, class_name = "")
	# 	ApplicationController.new.render_to_string(partial: 'partials/default_checkbox', 
 #      locals: {value: value, name: name, class_name: class_name, description: description, value_val: value_val}, 
 #      layout: false, formats: [:html], handlers: [:haml])
	# end

	# def message_errors
	# 	ApplicationController.new.render_to_string(partial: 'partials/message_errors', 
 #      locals: {}, 
 #      layout: false, formats: [:html], handlers: [:haml])
	# end

	# def rating(rating)
	# 	ApplicationController.new.render_to_string(partial: 'partials/rating', 
 #      locals: {rating: rating}, 
 #      layout: false, formats: [:html], handlers: [:haml])
	# end

	def pagginate(url, params_pagginate, page, params, class_page)
  	url_sort = ""
  	url_sort = "&sort=#{params[:sort]}" unless params[:sort].nil?
  	ApplicationController.new.render_to_string(partial: 'partials/pagginate', locals: {url: url, class_page: class_page, params_pagginate: params_pagginate, page: page, url_sort: url_sort}, layout: false, formats: [:html], handlers: [:haml])
  end

  def uploader_single(name, input_id, attach, del_class, allow_files)
    ApplicationController.new.render_to_string(partial: 'partials/uploader_single', 
      locals: {name: name, input_id: input_id, attach: attach, del_class: del_class, allow_files: allow_files}, 
      layout: false, formats: [:html], handlers: [:haml])
  end

  def uploader_many(name, input_id, attachs, del_class, allow_files)
    ApplicationController.new.render_to_string(partial: 'partials/uploader_many', 
      locals: {name: name, input_id: input_id, attachs: attachs, del_class: del_class, allow_files: allow_files}, 
      layout: false, formats: [:html], handlers: [:haml])
  end

  def pricing_index_index_path
    "#{Translation.current_lan == 'en' ? '' : '/'+Translation.current_lan}/pricing"
  end

  def privacy_policy_index_index_path
    "#{Translation.current_lan == 'en' ? '' : '/'+Translation.current_lan}/privacy_policy"
  end

  def about_index_index_path
    "#{Translation.current_lan == 'en' ? '' : '/'+Translation.current_lan}/about"
  end

  def mentors_index_index_path
    "#{Translation.current_lan == 'en' ? '' : '/'+Translation.current_lan}/mentors"
  end

  def terms_of_service_index_index_path
    "#{Translation.current_lan == 'en' ? '' : '/'+Translation.current_lan}/terms_of_service"
  end

  def root_path
    if Translation.current_lan == 'en'
      '/'
    else
      "/#{Translation.current_lan}"
    end
  end

  def faq_profiles_path(category)
    "#{Translation.current_lan == 'en' ? '' : '/'+Translation.current_lan}/faq/#{Filter.translit(category.alias.downcase)}-#{category.id}"
  end

  private

    def year_name(year)
      last_ch = year.to_s.mb_chars.last.to_i
      if last_ch == 1
        "year"
      elsif last_ch == 2 || last_ch == 3 || last_ch == 4
        "year"
      else
        "year"
      end
    end

    def month_name(month)
      last_ch = month.to_s.mb_chars.last.to_i
      if last_ch == 1
        "month"
      elsif last_ch == 2 || last_ch == 3 || last_ch == 4
        "month"
      else
        "month"
      end
    end

    def day_name(day)
      last_ch = day.to_s.mb_chars.last.to_i
      if last_ch == 1
        "day"
      elsif last_ch == 2 || last_ch == 3 || last_ch == 4
        "day"
      else
        "day"
      end
    end

    def hour_name(hour)
      last_ch = hour.to_s.mb_chars.last.to_i
      if last_ch == 1
        "hour"
      elsif last_ch == 2 || last_ch == 3 || last_ch == 4
        "hour"
      else
        "hour"
      end
    end

    def min_name(min)
      last_ch = min.to_s.mb_chars.last.to_i
      if last_ch == 1
        "minute"
      elsif last_ch == 2 || last_ch == 3 || last_ch == 4
        "minute"
      else
        "minute"
      end
    end
end
