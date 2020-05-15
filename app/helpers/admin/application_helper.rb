# coding: utf-8
module Admin::ApplicationHelper
	def admin_meta_title
    if @meta_title.nil?
      I18n.t("view.admin.common.title_default")
    else
      @meta_title
    end
  end

  def admin_pagginate(url, params_pagginate, page, params)
  	url_sort = ""
  	url_sort = "&sort=#{params[:sort]}" unless params[:sort].nil?
  	ApplicationController.new.render_to_string(partial: 'admin/partials/pagginate', locals: {url: url, params_pagginate: params_pagginate, page: page, url_sort: url_sort}, layout: false, formats: [:html], handlers: [:haml])
  end

  def admin_default_checkbox_tr
  	ApplicationController.new.render_to_string(partial: 'admin/partials/default_checkbox_tr', locals: {}, layout: false, formats: [:html], handlers: [:haml])
  end

  def admin_default_checkbox_th
  	ApplicationController.new.render_to_string(partial: 'admin/partials/default_checkbox_th', locals: {}, layout: false, formats: [:html], handlers: [:haml])
  end

  def admin_sort(url, name, params)
  	name_asc = name + '_asc'
  	name_desc = name + '_desc'
  	if params[:page].to_i > 0
  		url += params[:page]
  	else
  		url += "1"
  	end
  	ApplicationController.new.render_to_string(partial: 'admin/partials/sort', locals: {url: url, name_asc: name_asc, name_desc: name_desc, param_sort: params[:sort]}, layout: false, formats: [:html], handlers: [:haml])
  end

  def admin_select_enumerize(elements, element_select, name, i18n, class_li, is_init = true, init_text = I18n.t("view.admin.common.select_text"), cl_button = "width-350")
    ApplicationController.new.render_to_string(partial: 'admin/partials/select_enumerize', 
      locals: {elements: elements, element_select: element_select, is_init: is_init, name: name, class_li: class_li, init_text: init_text, cl_button: cl_button, i18n: i18n}, 
      layout: false, formats: [:html], handlers: [:haml])
  end

  def admin_select_numbers(elements, element_select, name, class_li, is_init = true, init_text = I18n.t("view.admin.common.select_text"), cl_button = "width-350")
    ApplicationController.new.render_to_string(partial: 'admin/partials/select_numbers', 
      locals: {elements: elements, element_select: element_select, is_init: is_init, name: name, class_li: class_li, init_text: init_text, cl_button: cl_button}, 
      layout: false, formats: [:html], handlers: [:haml])
  end
  
  def admin_select_standart(elements, element_select, name, class_li, is_init = true, init_text = I18n.t("view.admin.common.select_text"), cl_button = "width-350")
    ApplicationController.new.render_to_string(partial: 'admin/partials/select_standart', 
      locals: {elements: elements, element_select: element_select, is_init: is_init, name: name, class_li: class_li, init_text: init_text, cl_button: cl_button}, 
      layout: false, formats: [:html], handlers: [:haml])
  end

  def admin_check_box_standart(checked, data, name, class_name)
    ApplicationController.new.render_to_string(partial: 'admin/partials/check_box_standart',
      locals: {checked: checked, data: data, name: name, class_name: class_name},
      layout: false, formats: [:html], handlers: [:haml])
  end

  def admin_user_path(user)
    if user.role_kind == 'client'
      "/admin/users/#{user.id}/edit"
    elsif user.role_kind == 'mentor'
      "/admin/users/#{user.id}/edit_mentor"
    elsif user.role_kind == 'moderator' || user.role_kind == 'admin'
      "/admin/users/#{user.id}/edit_moderator"
    end
  end

  def admin_select_state(elements, element_select, name, i18n, class_li, is_init = true, init_text = I18n.t("view.admin.common.select_text"), cl_button = "width-350")
    ApplicationController.new.render_to_string(partial: 'admin/partials/select_state', 
      locals: {elements: elements, element_select: element_select, is_init: is_init, name: name, class_li: class_li, init_text: init_text, cl_button: cl_button, i18n: i18n}, 
      layout: false, formats: [:html], handlers: [:haml])
  end

  def admin_rating(rating)
    ApplicationController.new.render_to_string(partial: 'admin/partials/admin_rating', 
      locals: {rating: rating}, 
      layout: false, formats: [:html], handlers: [:haml])
  end

  def admin_property_detail_other(value, property_detail_other)
    ApplicationController.new.render_to_string(partial: 'admin/partials/admin_property_detail_other', 
      locals: {value: value, property_detail_other: property_detail_other}, 
      layout: false, formats: [:html], handlers: [:haml])
  end
end