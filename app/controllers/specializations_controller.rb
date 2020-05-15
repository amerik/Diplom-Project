# coding: utf-8
class SpecializationsController < ApplicationController
	inherit_resources

	def item_block
		render :json => { :item => render_to_string(partial: 'specializations/item', locals: {:specialization => Specialization.new, :i => params[:counts].to_i}, layout: false, formats: [:html], handlers: [:haml]) }
	end

	def create
		if @user_current.auth?
			unless params[:specializations].nil?
				ids = @user_current.profile.specializations.map{|v| v.id}
				params[:specializations].each do |item|
					specialization = item.last
					if specialization[:id].to_i > 0
						sp = Specialization.find(specialization[:id].to_i)
						sp.update_attributes(:name => specialization[:name], :company => specialization[:company], :industry => specialization[:industry], 
							:occupation => specialization[:occupation])
						ids.delete(sp.id)
					else
						@user_current.profile.specializations << Specialization.new(:name => specialization[:name], :company => specialization[:company], 
							:industry => specialization[:industry], :occupation => specialization[:occupation])
					end
				end
				ids.each do |sp_id|
					Specialization.delete(sp_id)
				end
				@user_current.update_attribute(:step_profile, params[:step_profile].to_i)
			end
			render :json => { :status => "success" }
		end
	end
end
