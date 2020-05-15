# coding: utf-8
module FieldsTranslation

	def self.included(base)
    base.class_eval do
    	has_many :translations, :as => :attach, :dependent => :destroy

      before_save :ensure_is_valid
    end
  end

	def create_with_fields(params, fields, lan = nil, validates = [])
		lan = Translation.current_lan if lan.nil?
    self.attributes = params
    valid_translation = true
    valid_translations = Hash.new
    fields.each do |value|
      if validates.include?(value.first) && (value.last == "" || value.last.nil?)
        valid_translation = false
        valid_translations[value.first] = [I18n.t("activerecord.errors.models.translation.attributes.#{value.first}.blank")]
      end
    end
    if self.valid? && valid_translation
      self.save
      fields.each do |value|
        Translation.create(:field => value.first, :value => value.last, :lan => lan) do |tr|
          tr.attach = self
        end
      end
      {:status => "success", :self => self}
    else
      {:status => "error", :errors => self.errors.messages.merge!(valid_translations)}
    end
  end

  def get_field(field, lan)
  	lan = Translation.current_lan if lan.nil?
  	translation = self.translations.by_field(field, lan).select("value").first
  	unless translation.nil?
  		translation.value
  	else
      value = self.translations.by_field(field, "en").select("value").first
      unless value.nil?
  		  value.value
      else
        nil
      end
  	end
  end

  def update_with_fields(params, fields, lan = nil, validates = [])
  	lan = Translation.current_lan if lan.nil?
    valid_translation = true
    valid_translations = Hash.new
    fields.each do |value|
      if validates.include?(value.first) && (value.last == "" || value.last.nil?)
        valid_translation = false
        valid_translations[value.first] = [I18n.t("activerecord.errors.models.translation.attributes.#{value.first}.blank")]
      end
    end
    if self.update_attributes(params) && valid_translation
	    fields.each do |value|
	      translation = self.translations.by_field(value.first, lan).first
	      if translation.nil?
	        Translation.create(:field => value.first, :value => value.last, :lan => lan) do |tr|
	          tr.attach = self
	        end
	      else
	        translation.update_attribute(:value, value.last)
	      end
	    end
	    {:status => "success", :self => self}
	  else
	  	{:status => "error", :errors => self.errors.messages.merge!(valid_translations)}
	  end
  end

  private 

    def ensure_is_valid
      if self.valid?
      else
      end
    end
end