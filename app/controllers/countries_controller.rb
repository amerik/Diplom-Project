# coding: utf-8
class CountriesController < ApplicationController
	inherit_resources

  def find_country
  	elements = Country.has_search(params[:country_text])
		render :json => { :countries => render_to_string(partial: 'partials/country_elements', 
      locals: {class_li:'set_country', elements: elements}, 
      layout: false, formats: [:html], handlers: [:haml]), count_countries: elements.count}  	
  end
end