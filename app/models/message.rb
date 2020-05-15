# coding: utf-8
class Message < ActiveRecord::Base
	belongs_to :user
	belongs_to :user_sender, class_name: 'User'
	belongs_to :chat
	has_many :message_items
	has_many :attachments, as: :attachable

	# validates :description, :presence => true

	# scope :by_my_new, -> (user_current) { where("user_id = ? and is_new = true", user_current.id) }
	scope :has_search, -> (text) { where("lower(messages.description) like lower(?) or lower(messages.name) like lower(?)", "%#{text}%", "%#{text}%") if !text.nil? && text != "" }
	scope :has_user, -> (user_id) { where("user_id = ?", user_id) }
	scope :has_user_sender, -> (user_sender_id) { where("messages.user_sender_id = ?", user_sender_id) }
	scope :by_chat, -> (user, user_other) { where("(user_sender_id = ? and user_id = ?) or (user_sender_id = ? and user_id = ?)", user.id, user_other.id, user_other.id, user.id) }
	scope :has_login, -> (login) { joins("left join users on users.id = messages.user_id").joins("left join profiles on profiles.user_id = users.id").where("profiles.user_name = ? or users.login = ?", login, login) if login != "" && !login.nil? }
	scope :has_sender_login, -> (login) { joins("left join users as user_senders on user_senders.id = messages.user_sender_id").joins("left join profiles as profile_senders on profile_senders.user_id = user_senders.id").where("profile_senders.user_name = ? or user_senders.login = ?", login, login) if login != "" && !login.nil? }
	scope :has_status, -> (status) { where("status = ?", status) }
	# scope :by_new, -> { where("is_new = true") }
	scope :has_chat, -> (chat_id) { where("chat_id = ?", chat_id) }
	scope :sort, -> (sn = "") { or_default(sn) }
	scope :or_default, -> (sn = "") { order("id asc") if sn == "" || sn.nil? }

	def get_other_user(user)
		if user.id == self.user_id
			self.user_sender
		else
			self.user
		end
	end

	state_machine :status, initial: :not_read do
    state :not_read
    state :read

    event :sent_read do
      transition :not_read => :read
    end

    event :sent_not_read do
      transition all => :not_read
    end     
  end

	# def self.is_new?(user, listing_id, user_sender)
	# 	Message.has_listing(listing_id).has_user(user.id).has_user_sender(user_sender.id).by_new.count > 0
	# end
end
