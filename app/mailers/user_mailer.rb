# coding: utf-8
class UserMailer < ApplicationMailer
	default from: SITE_EMAIL_FULL
  add_template_helper(ApplicationHelper)
  layout 'mailer'

  def register(user)
  	@user = user
  	mail to: @user.login, subject: "Registration on the site #{SITE_NAME_GLOBAL}", :content_type => 'text/html'
  end
end
