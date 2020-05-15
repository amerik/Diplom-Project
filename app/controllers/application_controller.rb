# coding: utf-8
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  layout :layout

  before_filter :get_current_user, :get_current_translation

  include PageNav

  protected

    def get_pages_params(page, count_for_page, count_elements)
      @params_pagginate = {}
      @params_pagginate[:page_number_left] = page_number_left(page, count_for_page)
      @params_pagginate[:page_number_right] = page_number_right(page, count_for_page, count_elements)
      @params_pagginate[:page_left] = page_left(page)
      @params_pagginate[:page_right] = page_right(page, @params_pagginate[:page_number_right], count_elements)
      @params_pagginate[:last_page] = get_last_page(count_elements, count_for_page)
      @params_pagginate[:get_left_pages] = get_left_pages(page)
      @params_pagginate[:get_right_pages] = get_right_pages(page, @params_pagginate[:last_page])
    end

    def init_paginate(per_page)
      @page = params[:page].to_i
      @page = 1 if @page < 1
      @per_page = params[:per_page].to_i
      @per_page = per_page if @per_page < 1
    end

    def init_meta(alias_name)
      @page_static = Page.find_by_alias(alias_name)
      @meta_title = @page_static.meta_tag.title
      @meta_description = @page_static.meta_tag.description
      @meta_keywords = @page_static.meta_tag.keywords
    end

    def create_guest
      @user_current = User.create(:role_kind => 'guest', :login => "guest@guest.guest#{User.count + 1}", :salt => "", :password => "guestguest", :access_token => "")
      cookies[:guest_id] = { :value => @user_current.id, :path => '/', :domain => :all, :expires => 356.days.from_now }
    end

  private

  	def get_current_user
      unless cookies[:is_auth_admin].nil?
        cookies[:is_auth_admin] = { :value => params[:is_auth_admin], :path => '/', :domain => :all, :expires => 356.days.from_now } unless params[:is_auth_admin].nil?
        User.is_auth_admin = (cookies[:is_auth_admin] == 'true')
      else
        unless params[:is_auth_admin].nil?
          cookies[:is_auth_admin] = { :value => params[:is_auth_admin], :path => '/', :domain => :all, :expires => 356.days.from_now }
          User.is_auth_admin = true
        else
          User.is_auth_admin = false
        end
      end
      Option.datetime_system = Option.set_datetime_system
      get_current_user_data

      times = Time.zone.to_s[4, 6].split(":")
      pos = 1
      pos = -1 if times[0].first == "-"
      @zone_interval = pos * (times[0].to_f.abs + times[1].to_f / 60)
	  end

  	def layout
      unless params[:controller].at('admin').nil?
        "admin/application"
      else
        "application"
      end
    end

    def get_current_user_data
      @user_current = UserAuthFilter.auth(cookies[:user_id], cookies[:user_value])
      if params[:controller].at('admin').nil?
        if !@user_current.mentor? && !@user_current.client?
          unless cookies[:guest_id].nil?
            @user_current = User.has_role('guest').where("id = ?", cookies[:guest_id].to_i).last
            if @user_current.nil?
              create_guest
            else
              @user_current.update_attribute(:created_at, Option.datetime_system)
            end
            if @user_current.nil?
              create_guest
            end
          else
            create_guest
          end
        end
      end
      
      @user_current.update_attribute(:online_at, Option.datetime_system) if params[:controller].at('admin').nil? || @user_current.auth_admin?
      User.hash_auto_fill = Digest::MD5.hexdigest("for a bot instead of captcha")
      User.time_auto_fill = DateTime.now
    end

    def get_current_translation
      unless cookies[:language].nil?
        Translation.current_lan = cookies[:language]
        Translation.current_lan = "en" unless Translation.lan.values.include?(cookies[:language])
      else
        Translation.current_lan = "en"
      end
      I18n.locale = Translation.current_lan
      cookies[:language] = { :value => Translation.current_lan, :path => '/', :domain => :all, :expires => 356.days.from_now }
    end

    def location_lan
      fields = request.fullpath.split('/')
      lan = fields[1]

      if Translation.current_lan == 'en'
        redirect_to "/#{fields[2, fields.size - 2].join('/')}" if Translation.lan.values.include?(lan)
      else
        if Translation.lan.values.include?(lan)
          redirect_to "/#{Translation.current_lan}/#{fields[2, fields.size - 2].join('/')}" if lan != Translation.current_lan
        else
          unless fields[1, fields.size - 1].nil?
            redirect_to "/#{Translation.current_lan}/#{fields[1, fields.size - 1].join('/')}"
          else
            redirect_to "/#{Translation.current_lan}"
          end
        end
      end
    end
end
