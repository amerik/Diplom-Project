Rails.application.routes.draw do
  root :to => 'index#index' 

  namespace :admin do
    root :to => 'index#index'

    resources :index do
      collection do
        get 'auth'
        get 'auth_all'
        get 'settings'
        get 'notifications'
        get 'moderator_privilege'
      end
    end

    resources :users do
      collection do
        get 'moderators'
        post 'authorization'
        get 'exit'
        get 'mentors'
        delete 'destroy_checking'
        get 'new_moderator'
        get 'new_mentor'      
      end
      member do
        post 'update_fast'
        get 'edit_moderator'
        get 'edit_mentor'
        get 'download_passport'
        post 'set_status_register'
        post 'delete_account'
        post 'update_password'
        get 'shedule_mentor'
        get 'set_mentor'
      end
    end

    resources :roles do
      member do
        post 'update_fast'
      end
      collection do
        delete 'destroy_checking'
      end
    end

    resources :privileges do
      collection do
        post 'set_role'
      end
    end

    resources :notifications

    resources :pages

    resources :options do
      member do
        post 'update_fast'
      end
    end

    resources :meta_tags do
      member do
        post 'update_fast'
      end
    end

    resources :achivments do
      member do
        post 'update_fast'
      end
      collection do
        delete 'destroy_checking'
      end
    end

    resources :partners do
      member do
        post 'update_fast'
      end
      collection do
        delete 'destroy_checking'
      end
    end 

    resources :reviews do
      member do
        post 'update_fast'
      end
      collection do
        delete 'destroy_checking'
      end
    end        

    resources :categories do
      member do
        post 'update_fast'
      end
      collection do
        delete 'destroy_checking'
      end
    end 

    resources :page_helps do
      member do
        post 'update_fast'
      end
      collection do
        delete 'destroy_checking'
      end
    end 

    resources :tasks

    resources :notes

    resources :countries do
      member do
        post 'update_fast'
      end
      collection do
        delete 'destroy_checking'
      end
    end

    resources :cities do
      member do
        post 'update_fast'
      end
      collection do
        delete 'destroy_checking'
      end
    end

    resources :universities do
      member do
        post 'update_fast'
      end
      collection do
        delete 'destroy_checking'
      end
    end

    resources :appoints do
      collection do
        post 'change_mentor'
      end
    end

    resources :request_users
  end

  resources :videos do
    collection do
      get 'current'
      get 'index'
      get 'make_call'
      get 'call_hangup'
      get 'get_call_status'
      get 'check_is_call'
      get 'answer_to_call'
      get 'get_slide'
      get 'video_call_block'
    end
  end

  resources :profiles do
    collection do
      get 'student'
      get 'my_student'
      get 'mentor'
      get 'student_edit'
      get 'check_social_url'
      post 'del_your_cv'
      post 'del_any_first'
      post 'del_any_second'
      get 'mentor_edit'
      get 'pricing'
      get 'faq'
      post 'search_page_help'
      get 'student_home'
      post 'set_image'
    end
  end
  match "/:lan/faq(/:alias)", :to => "profiles#faq", via: 'get'
  match "/faq(/:alias)", :to => "profiles#faq", via: 'get'
  
  resources :index do
    collection do
      get 'about'
      get 'pricing'
      get 'set_language'
      get 'mentors'
      get 'privacy_policy'
      get 'ui_elements'
      get 'terms_of_service'
      get 'test_call'
      get 'test_call2'
    end
  end

  match "/:lan/about", :to => "index#about", via: 'get'
  match "/about", :to => "index#about", via: 'get'
  match "/:lan/pricing", :to => "index#pricing", via: 'get'
  match "/pricing", :to => "index#pricing", via: 'get'
  match "/:lan/mentors", :to => "index#mentors", via: 'get'
  match "/mentors", :to => "index#mentors", via: 'get'
  match "/:lan/privacy_policy", :to => "index#privacy_policy", via: 'get'
  match "/privacy_policy", :to => "index#privacy_policy", via: 'get'
  match "/:lan/terms_of_service", :to => "index#terms_of_service", via: 'get'
  match "/terms_of_service", :to => "index#terms_of_service", via: 'get'

  resources :schedules do
    collection do
      get 'mentor'
      get 'student'
      post 'reading_mentor'
      get 'search_mentor'
      post 'set_user'
      get 'my_students'
      get 'my_mentor'
    end
    member do
      get 'update_tasks_notes_last'
      get 'check_end_lesson'
    end
  end

  resources :users do
    collection do
      get 'register_mentor'
      get 'register_student'
      get 'register_role_kind'
      get 'check_register'
      post 'authorization'
      post 'soc_authorization'       
      post 'request_mentor'  
      get 'exit'
    end
  end
  match "/users/soc_authorization(/:role_kind)", :to => "users#soc_authorization", via: 'post'
  
  resources :tasks do
    member do
      get 'get_form_edit'
    end
  end

  resources :notes do
    member do
      get 'get_form_edit'
    end
  end

  resources :errors do
    collection do
      get 'not_found'
      get 'unacceptable'
      get 'internal_error'
    end
  end

  resources :cities do
    collection do
      get 'select_by_country'
    end
  end

  resources :specializations do
    collection do
      get 'item_block'
    end
  end

  resources :baskets do
    collection do
      post 'del_all_new_baskets'
    end
  end

  resources :request_users

  resources :user_achivments do
    collection do
      get 'get_slide'
    end
  end

  resources :messages do
    collection do
      get 'update_last'
      get 'message_count'
    end
  end

  resources :notifications do
    collection do
      get 'get_notification_list'
      get 'send_read_all'
    end
  end

  resources :message_items do
    member do
      get 'download'
    end
  end

  resources :attachments do
    member do
      get 'download'
    end
  end

  resources :countries do
    collection do
      get 'find_country'
    end    
  end

  match "/404", :to => "errors#not_found", via: 'get'
  match "/422", :to => "errors#unacceptable", via: 'get'
  match "/500", :to => "errors#internal_error", via: 'get'

  # match "/:lan", :to => "index#index", via: 'get'

  match "/sitemap.xml", :to => "sitemap#index", via: 'get'

  match '*url', :to => "errors#not_found", via: 'get'
end
