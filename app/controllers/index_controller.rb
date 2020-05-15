# coding: utf-8
class IndexController < ApplicationController
	def index
		init_meta('index')
		@partners_per_slide = 4
		@partners = Partner.sort
		@reviews = Review.sort.limit(8)		
	end

	def ui_elements
	end
	
	def pricing
		init_meta('pricing')
	end

	def about
		init_meta('about')
	end

	def mentors
		init_meta('mentors')
		@mentors = User.has_role('mentor').sort.limit(8)
	end

	def privacy_policy
		init_meta('privacy_policy')
	end

	def set_language
  	Translation.current_lan = params[:language]
    I18n.locale = Translation.current_lan
    @user_current.update_attribute(:lan, Translation.current_lan)
    cookies[:language] = { :value => Translation.current_lan, :path => '/', :domain => :all, :expires => 356.days.from_now }
		redirect_to :back
	end

	def terms_of_service
		init_meta('terms_of_service')
	end

	def test_call
		render 'index/test_call', :layout => false
	end

	def test_call2
		render 'index/test_call2', :layout => false
	end
end
