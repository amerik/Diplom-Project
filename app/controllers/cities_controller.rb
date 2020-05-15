# coding: utf-8
class CitiesController < ApplicationController
	inherit_resources

	def select_by_country
		render :json => { :cities => render_to_string(partial: 'cities/select_by_country', locals: {cities: City.has_country(params[:country_id].to_i).sort, city: nil}, layout: false, formats: [:html], handlers: [:haml]) }
	end
end
