# coding: utf-8
class Chat < ActiveRecord::Base
	belongs_to :user_first, class_name: "User"
	belongs_to :user_second, class_name: "User"
	has_many :messages, :dependent => :destroy

	scope :by_user, -> (user_first_id) { where("chats.user_first_id = ? or chats.user_second_id = ?", user_first_id, user_first_id) }
	scope :by_user_and_sender, -> (user_first_id, user_second_id) { where("(user_first_id = ? and user_second_id = ?) or (user_first_id = ? and user_second_id = ?)", user_first_id, user_second_id, user_second_id, user_first_id) }
	scope :has_message_kind, -> (kind) { joins(:messages).where("messages.kind = ?", kind) }
	scope :has_user_by_my, -> (user_id, user_current) { where("(chats.user_first_id = ? and chats.user_second_id = ?) or (chats.user_first_id = ? and chats.user_second_id = ?)", user_id, user_current.id, user_current.id, user_id) if user_id.to_i > 0 }
	scope :sort, -> (sn = "") { or_default(sn) }
	scope :or_default, -> (sn = "") { order("id desc") if sn == "" || sn.nil? }
	# scope :has_show, -> (show, user_current) { by_not_read(show, user_current).by_read(show, user_current) }
	# scope :by_not_read, -> (show, user_current) { where("messages.is_new = true and messages.user_id = ?", user_current.id) if show == 'unread' }
	# scope :by_read, -> (show, user_current) { having("sum(CASE WHEN messages.is_new = true THEN 1 ELSE 0 END) = 0").where("messages.user_id = ?", user_current.id) if show == 'read' }

	def get_sender_user(user, user_current)
		if user.nil?
			if self.user_first_id == user_current.id
				self.user_second
			else
				self.user_first
			end
		else
			if self.user_first_id == user.id
				self.user_second
			else
				self.user_first
			end
		end
	end
end
