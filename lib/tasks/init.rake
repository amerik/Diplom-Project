# coding: utf-8

# bundle exec rake tables:init

namespace :tables do
  desc "Initialize all params in tables"
  task :init => :environment do
  	# обнуляем данные
    Profile.delete_all
    User.delete_all
    Privilege.delete_all
    Role.delete_all
    Notification.delete_all
    Chat.delete_all
    Review.delete_all
    Payment.delete_all
    Option.delete_all
    MetaTag.delete_all
    Translation.delete_all
    Page.delete_all
    Achivment.delete_all
    UserAchivment.delete_all
    Schedule.delete_all
    Video.delete_all
    Task.delete_all
    Note.delete_all
    University.delete_all
    Partner.delete_all
    Category.delete_all
    PageHelp.delete_all
    Message.delete_all
    MessageItem.delete_all
    Translation.current_lan = "en"

    ########################################################################
    #========================= РОЛИ ДЛЯ МОДЕРАТОРОВ СИСТЕМЫ ================
    ########################################################################

    role2 = Role.create(:name => "Moderator for booking")
    role1 = Role.create(:name => "Moderator for messages")

    Privilege.create(:role_id => role1.id, :page_name => 'massages', :action_name => 'see')
    Privilege.create(:role_id => role1.id, :page_name => 'massages', :action_name => 'delete')
    Privilege.create(:role_id => role1.id, :page_name => 'massages', :action_name => 'create')
    Privilege.create(:role_id => role1.id, :page_name => 'massages', :action_name => 'answer')
    Privilege.create(:role_id => role1.id, :page_name => 'massages', :action_name => 'export')
    Privilege.create(:role_id => role1.id, :page_name => 'massages', :action_name => 'edit')

    Privilege.create(:role_id => role2.id, :page_name => 'bookings', :action_name => 'see')
    Privilege.create(:role_id => role2.id, :page_name => 'bookings', :action_name => 'delete')
    Privilege.create(:role_id => role2.id, :page_name => 'bookings', :action_name => 'create')
    Privilege.create(:role_id => role2.id, :page_name => 'bookings', :action_name => 'answer')
    Privilege.create(:role_id => role2.id, :page_name => 'bookings', :action_name => 'export')
    Privilege.create(:role_id => role2.id, :page_name => 'bookings', :action_name => 'edit')

    p "-->> ПОЛЬЗОВАТЕЛИ СИСТЕМЫ"
    ########################################################################
    #========================= ПОЛЬЗОВАТЕЛИ СИСТЕМЫ ========================
    ########################################################################

    1.upto(10) do |i|
      University.create(:name => "ASTON UNIVERSITY #{i}", :position => i)
    end

    # администраторы

    res = UserAuthFilter.add(User.new(:role_kind => "admin", :login => "admin@gmail.com", :password => "113355"), "113355", Profile.new(:last_name => 'Ivanov', :phone => "89269675681"))
    admin = res[:user]
    admin.update_attribute(:status_register, true)

    res = UserAuthFilter.add(User.new(:role_kind => "moderator", :role_id => role1.id, :login => "moder1@gmail.com", :password => "113355"), "113355", Profile.new(:last_name => 'Smit', :phone => "89269675681"))
    moder1 = res[:user]
    moder1.update_attribute(:status_register, true)

    res = UserAuthFilter.add(User.new(:role_kind => "moderator", :role_id => role2.id, :login => "moder2@gmail.com", :password => "113355"), "113355", Profile.new(:last_name => 'Dgons', :phone => "89269675681"))
    moder2 = res[:user]
    moder2.update_attribute(:status_register, true)

    res = UserAuthFilter.add(User.new(:role_kind => "moderator", :login => "moder3@gmail.com", :password => "113355"), "113355", Profile.new(:last_name => 'Petrov', :phone => "89269675681"))
    moder3 = res[:user]
    moder3.update_attribute(:status_register, true)

    res = UserAuthFilter.add(User.new(:role_kind => "admin", :login => "admin1@gmail.com", :password => "367367"), "367367", Profile.new(:last_name => 'Ivanov', :phone => "89269675681"))
    admin2 = res[:user]
    admin2.update_attribute(:status_register, true)

    # clients

    res = UserAuthFilter.add(User.new(:role_kind => "client", :login => "client1@gmail.com", :password => "113355", :step_profile => 3, :mentor_status => 'not_assigned'), "113355", Profile.new(:last_name => 'Petrov', :first_name => "Ivan", :phone => "89269675681"))
    client1 = res[:user]
    client1.update_attribute(:status_register, true)

    res = UserAuthFilter.add(User.new(:role_kind => "client", :login => "client2@gmail.com", :password => "113355", :step_profile => 3, :mentor_status => 'not_assigned'), "113355", Profile.new(:last_name => 'Ivanov', :first_name => "Ivan", :phone => "89269675681"))
    client2 = res[:user]
    client2.update_attribute(:status_register, true)

    res = UserAuthFilter.add(User.new(:role_kind => "client", :login => "client3@gmail.com", :password => "113355", :mentor_status => 'not_assigned'), "113355", Profile.new(:last_name => 'Smit', :first_name => "Ivan", :phone => "89269675681"))
    client3 = res[:user]
    client3.update_attribute(:status_register, true)

    res = UserAuthFilter.add(User.new(:role_kind => "client", :login => "client4@gmail.com", :password => "113355", :mentor_status => 'not_assigned'), "113355", Profile.new(:last_name => 'Dgons', :first_name => "Ivan", :phone => "89269675681"))
    client4 = res[:user]
    client4.update_attribute(:status_register, true)

    res = UserAuthFilter.add(User.new(:role_kind => "client", :login => "client5@gmail.com", :password => "113355", :mentor_status => 'not_assigned'), "113355", Profile.new(:last_name => 'Li', :first_name => "Ivan", :phone => "89269675681"))
    client5 = res[:user]
    client5.update_attribute(:status_register, true)

    # mentors

    res = UserAuthFilter.add(User.new(:role_kind => "mentor", :login => "mentor1@gmail.com", :password => "113355", :step_profile => 3), "113355", Profile.new(:last_name => 'Petrov', :first_name => "Ivan", :phone => "89269675681"))
    mentor1 = res[:user]
    mentor1.update_attribute(:status_register, true)

    res = UserAuthFilter.add(User.new(:role_kind => "mentor", :login => "mentor2@gmail.com", :password => "113355"), "113355", Profile.new(:last_name => 'Ivanov', :first_name => "Ivan", :phone => "89269675681"))
    mentor2 = res[:user]
    mentor2.update_attribute(:status_register, true)

    res = UserAuthFilter.add(User.new(:role_kind => "mentor", :login => "mentor3@gmail.com", :password => "113355"), "113355", Profile.new(:last_name => 'Ivanov', :first_name => "Ivan", :phone => "89269675681"))
    mentor3 = res[:user]
    mentor3.update_attribute(:status_register, true)

    res = UserAuthFilter.add(User.new(:role_kind => "mentor", :login => "mentor4@gmail.com", :password => "113355"), "113355", Profile.new(:last_name => 'Ivanov', :first_name => "Ivan", :phone => "89269675681"))
    mentor4 = res[:user]
    mentor4.update_attribute(:status_register, true)        

    res = UserAuthFilter.add(User.new(:role_kind => "mentor", :login => "mentor5@gmail.com", :password => "113355"), "113355", Profile.new(:last_name => 'Ivanov', :first_name => "Ivan", :phone => "89269675681"))
    mentor5 = res[:user]
    mentor5.update_attribute(:status_register, true)  


    p "-->> СТАТИЧЕСКИЕ СТРАНИЦЫ"
    ########################################################################
    #========================= СТАТИЧЕСКИЕ СТРАНИЦЫ ========================
    ########################################################################

    page1 = Page.new.create_with_fields({:name => "Home", :alias => 'index'}, {:h1 => "Home", :description => ""})[:self]
    page1.meta_tag = MetaTag.new.create_with_fields({}, {:title => "Home | Eleway.com", :keywords => "Home", :description => "Home"})[:self]

    page2 = Page.new.create_with_fields({:name => "About", :alias => 'about'}, {:h1 => "About", :description => ""})[:self]
    page2.meta_tag = MetaTag.new.create_with_fields({}, {:title => "About | Eleway.com", :keywords => "About", :description => "About"})[:self]

    page3 = Page.new.create_with_fields({:name => "Pricing", :alias => 'pricing'}, {:h1 => "Pricing", :description => ""})[:self]
    page3.meta_tag = MetaTag.new.create_with_fields({}, {:title => "Pricing | Eleway.com", :keywords => "Pricing", :description => "Pricing"})[:self]

    page4 = Page.new.create_with_fields({:name => "Mentors", :alias => 'mentors'}, {:h1 => "Mentors", :description => ""})[:self]
    page4.meta_tag = MetaTag.new.create_with_fields({}, {:title => "Mentors | Eleway.com", :keywords => "Mentors", :description => "Mentors"})[:self]

    page5 = Page.new.create_with_fields({:name => "Privacy policy", :alias => 'privacy_policy'}, {:h1 => "Privacy policy", :description => ""})[:self]
    page5.meta_tag = MetaTag.new.create_with_fields({}, {:title => "Privacy policy | Eleway.com", :keywords => "Privacy policy", :description => "Privacy policy"})[:self]

    page6 = Page.new.create_with_fields({:name => "Terms of service", :alias => 'terms_of_service'}, {:h1 => "Terms of service", :description => ""})[:self]
    page6.meta_tag = MetaTag.new.create_with_fields({}, {:title => "Terms of service | Eleway.com", :keywords => "Terms of service", :description => "Terms of service"})[:self]

    #################################### end ###################################

    p "-->> РАСПИСАНИЕ"
    ########################################################################
    #===================================== РАСПИСАНИЕ ======================
    ########################################################################

    schedules = Array.new
    1.upto(5) do |day|
      1.upto(10) do |i|
        schedule1 = Schedule.create(:mentor_id => mentor1.id, :start_at => DateTime.new(2018, 11, 10, 7, 0, 0) + day.days + i.hours, :kind => 'hour_1')
        schedules << schedule1
      end
    end

    schedules[0].user = client1
    schedules[0].save
    Appoint.create(:user_id => client1.id, :mentor_id => schedules[0].mentor_id, :moderator_id => moder1.id)
    client1.sent_assign

    schedules[3].user = client2
    schedules[3].save
    Appoint.create(:user_id => client2.id, :mentor_id => schedules[3].mentor_id, :moderator_id => moder2.id)
    client2.sent_assign

    1.upto(50) do |i|
      Note.create(:name => "Note #{i}", :description => "Description for note #{i}") do |n|
        n.schedule = schedules[rand(3) + 1]
      end
    end

    #################################### end ###################################


    p "-->> АЧИВКИ"
    ########################################################################
    #========================================= АЧИВКИ ======================
    ########################################################################

    achivments = Array.new
    1.upto(30) do |i|
      achivment1 = Achivment.new.create_with_fields({:alias => "achivment-#{i}"}, {:name => "Achivment №#{i}", :description => ""})[:self]
      achivment1.image = File.open('./public/achivments/1.png')
      achivment1.save
      achivments << achivment1
    end

    task_1 = Task.create(:description => "You need to learn a lesson in 10 minutes") do |t|
      t.schedule = schedules[0]
      t.achivment = achivments[2]
    end
    UserAchivment.create(:description => "You need to learn a lesson in 10 minutes") do |ua|
      ua.achivment = achivments[2]
      ua.user = client1
      ua.task = task_1
    end

    task_2 = Task.create(:description => "You need to learn a lesson in 8 minutes") do |t|
      t.schedule = schedules[0]
      t.achivment = achivments[3]
    end
    UserAchivment.create(:description => "You need to learn a lesson in 8 minutes") do |ua|
      ua.achivment = achivments[3]
      ua.user = client1
      ua.task = task_2
    end

    task_3 = Task.create(:description => "You need to learn a lesson in 9 minutes") do |t|
      t.schedule = schedules[0]
      t.achivment = achivments[4]
    end
    UserAchivment.create(:description => "You need to learn a lesson in 9 minutes") do |ua|
      ua.achivment = achivments[4]
      ua.user = client1
      ua.task = task_3
    end

    task_4 = Task.create(:description => "You need to learn a lesson in 15 minutes") do |t|
      t.schedule = schedules[3]
      t.achivment = achivments[4]
    end
    UserAchivment.create(:description => "You need to learn a lesson in 15 minutes") do |ua|
      ua.achivment = achivments[4]
      ua.user = client2
      ua.task = task_4
    end

    user_achivment_1 = UserAchivment.create(:description => "Good job!") do |ua|
      ua.achivment = achivments[rand(30)]
      ua.user = client1
    end

    user_achivment_2 = UserAchivment.create(:description => "Good job!") do |ua|
      ua.achivment = achivments[rand(30)]
      ua.user = client1
    end

    user_achivment_3 = UserAchivment.create(:description => "Good job!") do |ua|
      ua.achivment = achivments[rand(30)]
      ua.user = client2
    end

    user_achivment_4 = UserAchivment.create(:description => "Good job!") do |ua|
      ua.achivment = achivments[rand(30)]
      ua.user = client3
    end

    #################################### end ###################################


    p "-->> ПАРТНЕРЫ"
    ########################################################################
    #========================================= ПАРТНЕРЫ ======================
    ########################################################################

    partner_1 = Partner.new.create_with_fields({:position => 1}, {:title => "Amazon"})[:self]
    partner_1.image = File.open('./public/partners/amazon.png')
    partner_1.save

    partner_2 = Partner.new.create_with_fields({:position => 2}, {:title => "Oracle"})[:self]
    partner_2.image = File.open('./public/partners/oracle.png')
    partner_2.save

    partner_3 = Partner.new.create_with_fields({:position => 3}, {:title => "Google"})[:self]
    partner_3.image = File.open('./public/partners/google.png')
    partner_3.save

    partner_4 = Partner.new.create_with_fields({:position => 4}, {:title => "Microsoft"})[:self]
    partner_4.image = File.open('./public/partners/microsoft.png')
    partner_4.save
           
    #################################### end ###################################


    p "-->> ОТЗЫВЫ"
    ########################################################################
    #========================================= ОТЗЫВЫ ======================
    ########################################################################
    mentors = [mentor1, mentor2, mentor3, mentor4, mentor5]
    mentors.each do |mentor|
      review_1 = Review.new.create_with_fields({:position => 1, :user_id => mentor.id}, {:name => "JENNA SIMPSON 1", :location => "Drop Box", :description => "1 As we passed, I remarked a beautiful church-spire rising above some old elms in the park; and before them, in the midst of a lawn, and some outhouses, an old red house with tall chimneys covered with ivy, and the windows shining in the sun"})[:self]
      review_1.image = File.open('./public/reviews/Hanna_Dormunx165.png')
      review_1.save

      review_2 = Review.new.create_with_fields({:position => 2, :user_id => mentor.id}, {:name => "JENNA SIMPSON 2", :location => "Drop Box", :description => "2 As we passed, I remarked a beautiful church-spire rising above some old elms in the park; and before them, in the midst of a lawn, and some outhouses, an old red house with tall chimneys covered with ivy, and the windows shining in the sun"})[:self]
      review_2.image = File.open('./public/reviews/Userpic2.jpg')
      review_2.save

      review_3 = Review.new.create_with_fields({:position => 3, :user_id => mentor.id}, {:name => "SMITH", :location => "Facebook", :description => "3 As we passed, I remarked a beautiful church-spire rising above some old elms in the park; and before them, in the midst of a lawn, and some outhouses, an old red house with tall chimneys covered with ivy, and the windows shining in the sun"})[:self]
      review_3.image = File.open('./public/reviews/Userpic3.jpg')
      review_3.save

      review_4 = Review.new.create_with_fields({:position => 4, :user_id => mentor.id}, {:name => "JENNA SIMPSON 4", :location => "Drop Box", :description => "4 As we passed, I remarked a beautiful church-spire rising above some old elms in the park; and before them, in the midst of a lawn, and some outhouses, an old red house with tall chimneys covered with ivy, and the windows shining in the sun"})[:self]
      review_4.image = File.open('./public/reviews/Userpic4.jpg')
      review_4.save

      review_5 = Review.new.create_with_fields({:position => 5, :user_id => mentor.id}, {:name => "Rodriguez", :location => "Drop Box", :description => "5 As we passed, I remarked a beautiful church-spire rising above some old elms in the park; and before them, in the midst of a lawn, and some outhouses, an old red house with tall chimneys covered with ivy, and the windows shining in the sun"})[:self]
      review_5.image = File.open('./public/reviews/Userpic5.jpg')
      review_5.save
    end
           
    #################################### end ###################################

    p "-->> КАТЕГОРИ / FAQ"
    ########################################################################
    #========================================= КАТЕГОРИ ======================
    ########################################################################
    %w(client mentor).each do |kind| 
      category_1 = Category.new.create_with_fields({:alias => 'popular', :kind => kind, :position => 0 }, {:name => "GENERAL QUESTIONS"})[:self]
      category_2 = Category.new.create_with_fields({:alias => 'customize', :kind => kind, :position => 0 }, {:name => "SERVICE SETTINGS"})[:self]
      category_3 = Category.new.create_with_fields({:alias => 'study', :kind => kind, :position => 0 }, {:name => "LEARNING PROCESS"})[:self]
      category_4 = Category.new.create_with_fields({:alias => 'pricing', :kind => kind, :position => 0 }, {:name => "PAYMENT QUESTIONS"})[:self]
      category_5 = Category.new.create_with_fields({:alias => 'faq', :kind => kind, :position => 0 }, {:name => "OTHER"})[:self]

      category_1.page_helps << PageHelp.new.create_with_fields({:category_id => category_1.id},{:name => 'How can I buy a subscription on your service?', :description => '<p>The event format concentrates the CTR, relying on insider information. The reach of the audience, discarding details, produces a public image. Communication concentrates the convergent budget for placement. The art of media planning, analyzing the results of an advertising campaign, strengthens the method of studying the market</p> 
          <p>The non-standard approach pushes the reach of the audience. The consumption society methodically attracts the image. The art of media planning, neglecting details, is amazing Still have questions?</p> '})[:self]
      category_1.page_helps << PageHelp.new.create_with_fields({:category_id => category_1.id},{:name => 'Why do I need to enter my credit card for the free trial?', :description => '<p>The event format concentrates the CTR, relying on insider information. The reach of the audience, discarding details, produces a public image. Communication concentrates the convergent budget for placement. The art of media planning, analyzing the results of an advertising campaign, strengthens the method of studying the market</p> 
          <p>The non-standard approach pushes the reach of the audience. The consumption society methodically attracts the image. The art of media planning, neglecting details, is amazing Still have questions?</p> '})[:self]
      category_1.page_helps << PageHelp.new.create_with_fields({:category_id => category_1.id},{:name => 'How to install plugin for video communication?', :description => '<p>The event format concentrates the CTR, relying on insider information. The reach of the audience, discarding details, produces a public image. Communication concentrates the convergent budget for placement. The art of media planning, analyzing the results of an advertising campaign, strengthens the method of studying the market</p> 
          <p>The non-standard approach pushes the reach of the audience. The consumption society methodically attracts the image. The art of media planning, neglecting details, is amazing Still have questions?</p> '})[:self]
      category_1.page_helps << PageHelp.new.create_with_fields({:category_id => category_1.id},{:name => 'How to create and add company information in profile?', :description => '<p>The event format concentrates the CTR, relying on insider information. The reach of the audience, discarding details, produces a public image. Communication concentrates the convergent budget for placement. The art of media planning, analyzing the results of an advertising campaign, strengthens the method of studying the market</p> 
          <p>The non-standard approach pushes the reach of the audience. The consumption society methodically attracts the image. The art of media planning, neglecting details, is amazing Still have questions?</p> '})[:self]
      category_1.page_helps << PageHelp.new.create_with_fields({:category_id => category_1.id},{:name => 'How to update the theme after a new version is released?', :description => '<p>The event format concentrates the CTR, relying on insider information. The reach of the audience, discarding details, produces a public image. Communication concentrates the convergent budget for placement. The art of media planning, analyzing the results of an advertising campaign, strengthens the method of studying the market</p> 
          <p>The non-standard approach pushes the reach of the audience. The consumption society methodically attracts the image. The art of media planning, neglecting details, is amazing Still have questions?</p> '})[:self]
      category_1.save                        
    end
    #################################### end ###################################    

    ########################################################################
    #========================= НАПОМИНАНИЯ =================================
    ########################################################################
    # Notification.create(:name => "Test", :role => 'client', :user_id => client1.id, :description => "Test text text text text...", :kind => 'new_session')
    # Notification.create(:name => "Test", :role => 'client', :user_id => client1.id, :description => "Test text text text text...", :kind => 'new_session')
    # Notification.create(:name => "Test", :role => 'client', :user_id => client1.id, :description => "Test text text text text...", :kind => 'new_session')
    # Notification.create(:name => "Test", :role => 'client', :user_id => client1.id, :description => "Test text text text text...", :kind => 'new_session')
    
  end
end