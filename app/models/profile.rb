# coding: utf-8
class Profile < ActiveRecord::Base
	belongs_to :user
  belongs_to :city
  belongs_to :country  
  belongs_to :university
  has_many :specializations, :dependent => :destroy
  has_many :attachments, :as => :attachable, :dependent => :destroy

	before_update :clear_phone
  before_save :clear_phone
  before_create :clear_phone

  include Image # 42x42 130x130
  mount_uploader :image, ProfileUploader

  extend Enumerize
  enumerize :sex, in: %w(man woman), predicates: true
  enumerize :time_preference, in: %w(morning afternoon evening hight), predicates: true
  enumerize :price_preference, in: %w(v_8_12 v_13_17 v_18_22 v_22_26 v_27), predicates: true

  def get_your_cv
    self.attachments.has_kind('your_cv').order("id asc").last
  end

  def get_any_first
    self.attachments.has_kind('any_first').order("id asc").last
  end

  def get_any_second
    self.attachments.has_kind('any_second').order("id asc").last
  end

	private

    def clear_phone
      self.phone = self.phone.gsub(/[^0-9]/, '') unless self.phone.nil?
    end
end
