//= require ui
//= require lib/attachment_submit
//= require lib/jquery.datetimepicker

//= require lib/jquery.mCustomScrollbar.concat.min
//= require lib/jquery.mask

root = exports ? this
root.callback_confirm

window.print_valid_errors = (entity, errors) ->
  $.each errors, (i, v) ->
    $('#'+entity+'_'+i).closest('.input-container').addClass('error')
    $('#'+entity+'_'+i).closest('.input-container').find('.error_message').html(v[0])

    $('#'+entity+'_'+i).closest('.calendar-container').addClass('error')
    $('#'+entity+'_'+i).closest('.calendar-container').find('.error_message').html(v[0])

    $('#'+entity+'_'+i).closest('.dropdown-container').addClass('error')
    $('#'+entity+'_'+i).closest('.dropdown-container').find('.error_message').html(v[0])

    $('#'+entity+'_'+i).closest('.file-container').addClass('error')
    $('#'+entity+'_'+i).closest('.file-container').find('.error_message').html(v[0])

window.clear_form = (form) ->
  form.find('.message_errors > ul').html('')
  form.get(0).reset()
  $('.modal').modal('hide')

window.message_error_ajax = () ->
  message_error("System error")
  set_sent_request(true)

window.message_success = (text) ->
  # $('#success_modal').find('.success_message').html(text)
  # $('#success_modal').modal('show')
  alert(text)

window.message_error = (text) ->
  if typeof text == 'object'
    str = ""
    $.each text, (i, v) ->
      str += '<li>'+v+'</li>'
    text = '<ul>' + str + '</ul>'
  else
  # $('#error_modal').find('.error_message').html(text)
  # $('#error_modal').modal('show')
  alert(text)

window.message_info = (text) ->
  if typeof text == 'object'
    str = ""
    $.each text, (i, v) ->
      str += '<li>'+v+'</li>'
    text = '<ul>' + str + '</ul>'
  else
  # $('#error_modal').find('.error_message').html(text)
  # $('#error_modal').modal('show')
  alert(text)

window.modal_confirm = (text, text_yes, text_no, callback) ->
  root.callback_confirm = callback
  $('#yes_no_modal').find('.description').html(text)
  $('#yes_no_modal').find('.yes').text(text_yes)
  $('#yes_no_modal').find('.no').text(text_no)
  $('#yes_no_modal').modal('show')

root.CKupdate = ->
  CKEDITOR.instances[instance].updateElement() for instance of CKEDITOR.instances

root.create_entity = (form, callback) ->
  ajax_sendform form, $(this), 'POST', '', [],
    success: (data,status,xhr) ->
      if data['status'] == 'success'
        if !callback
          if data['url'] != "" && data['url'] != undefined
            window.location.href = data['url']
          else
            message_success(data['message'])
            clear_form(form)
        else
          callback(data)
      else
        print_valid_errors(data['entity'], data['errors'])
      set_sent_request(true)
    error: (xhr,status,error) ->
      message_error_ajax()

root.update_entity = (form, callback) ->
  ajax_sendform form, $(this), 'PUT', '', [],
    success: (data,status,xhr) ->
      if data['status'] == 'success'
        if !callback
          if data['url'] != "" && data['url'] != undefined
            window.location.href = data['url']
          else
            message_success(data['message'])
            clear_form(form)
        else
          callback(data)
      else
        print_valid_errors(data['entity'], data['errors'])
      set_sent_request(true)
    error: (xhr,status,error) ->
      message_error_ajax()

somebody_writing_close = ->
  $('.chat-block .somebody-writing').addClass('hidden')

window.update_chat = ->
  last_id = $('.chat-item').last().data('id')
  $.getJSON "/messages/update_last", {last_id: last_id, chat_id: $('#message_chat_id').attr('value')}, (data) ->
    if parseInt(data['count_messages']) > 0
      $('.chat-block .somebody-writing').removeClass('hidden')
      window.setTimeout(somebody_writing_close, 2000)
      $('.chat_body .mCSB_container').append(data['messages'])
      $('.chat-block .chat-area').mCustomScrollbar("scrollTo", "#message-"+last_id)
    window.setTimeout(update_chat, 4000)

$(document).ready ->
  
  $('.ui.dropdown .dropdown-list').mCustomScrollbar
    axis: "y"
    theme: "dark" 

  $('.date_of_year').mask('00.00.0000')
  $('.year_mask').mask('9999')

  if $('#user_chat_update').attr('value') == 'true'
    update_chat()

  $('#yes_no_modal .yes').click (event) ->
    event.preventDefault()
    callback_confirm()
    $('#yes_no_modal').modal('hide')
  
  $('form input').keyup ->
    if $(this).closest('.input-container').hasClass('error')
      $(this).closest('.input-container').removeClass('error')

  $('form textarea').keyup ->
    if $(this).closest('.textarea-container').hasClass('error')
      $(this).closest('.textarea-container').removeClass('error')

  $('.create_entity').click (event) ->
    event.preventDefault()
    create_entity($(this).closest('form'))

  $('.create_entity_ck').click (event) ->
    event.preventDefault()
    CKupdate()
    create_entity($(this).closest('form'))

  $('#request_user_email').keypress (event)->
    if(event.which == 10 || event.which == 13) 
      event.preventDefault()
      create_entity($(this).closest('form'))
      

  $(document).on 'click', '.update_entity', (event) ->
    event.preventDefault()
    update_entity($(this).closest('form'))

  $(document).on 'click', '.update_entity_ck', (event) ->
    event.preventDefault()
    CKupdate()
    update_entity($(this).closest('form'))

  $('.log-in').click (event) ->
    event.preventDefault()
    $('.auth').modal('hide')
    $('#log_in_modal').modal('show')

  $('.sign-up').click (event) ->
    event.preventDefault()
    $('.auth').modal('hide')
    $('#sign_up_modal').modal('show')    

  $('.forgot-password').click (event) ->
    event.preventDefault()
    $('.auth').modal('hide')
    $('#forgot_password_modal').modal('show')

  $('#forgot_password_modal .back_to_login').click (event) ->
    event.preventDefault()
    $('.auth').modal('hide')
    $('#log_in_modal').modal('show')  

  $('.create_user').click (event) ->
    event.preventDefault()
    form = $(this).closest('form')
    ajax_sendform form, $(this), 'POST', 'user', ['login', 'password', 'password_confirmation'],
      success: (data,status,xhr) ->
        if data['status'] == 'success'
          clear_form(form)
          message_success(data['message'])
        else
          print_valid_errors('user', data['errors'])
        set_sent_request(true)
      error: (xhr,status,error) ->
        message_error_ajax()

  $('.user_authorization').click (event) ->
    event.preventDefault()
    form = $(this).closest('form')
    ajax_sendform form, $(this), 'POST', 'user', ['login_auth', 'password_auth'],
      success: (data,status,xhr) ->
        if data['status'] == 'success'
          clear_form(form)
          window.location.href = data['url']
        else
          print_valid_errors('user_auth', data['errors'])
        set_sent_request(true)
      error: (xhr,status,error) ->
        message_error_ajax()

  $('.log_in_enter').keypress (event) ->
    if(event.which == 13)
      $('.user_authorization').click()

  $('.birth_at_field').datetimepicker
    lang: "en",
    timepicker: false,
    datepicker: true,
    format: 'd.m.Y',
    scrollMonth : false,
    scrollInput : false,
    maxDate: new Date(),
    closeOnDateSelect: true,
    onGenerate: (dp, $input) ->
      if $($input).parent().hasClass('relative')
        $(this).css({'top':'inherit', 'left':'0px'})
        $($input).parent().append($(this))
    onChangeDateTime: (dp, $input) ->
      $input.closest('.calendar-container').find('input').val($input.val())
      $input.closest('.calendar-container').removeClass('error')

  $('.set_country').click (event)->
    event.preventDefault()
    $.getJSON "/cities/select_by_country", {country_id: $(this).data('id')}, (data) ->
      $('.cities_body').html(data['cities'])
      $('.ui.dropdown .dropdown-list').mCustomScrollbar
        axis: "y"
        theme: "dark"

  $('.add_new_specialization').click (event)->
    event.preventDefault()
    el = $(this)
    counts = parseInt($(this).data('counts'))
    $.getJSON "/specializations/item_block", {counts: counts}, (data) ->
      el.data('counts', counts + 1)
      $('.specializations_body').append(data['item'])

  $(document).on 'click', '.del_item_specialization', (event) ->
    event.preventDefault()
    $(this).closest('.add_comapny').remove()
    el = $('.add_new_specialization')

  $('.check_social_url').click (event)->
    event.preventDefault()
    el = $(this)
    $.getJSON "/profiles/check_social_url", {soc: $(this).data('soc'), url: $('.soc_'+$(this).data('soc')).val()}, (data) ->
      if data['status'] == "success"
        $('.soc_'+el.data('soc')).closest('.input-container').removeClass('error')
        $('.soc_'+el.data('soc')).closest('.input-container').addClass('success')
      else
        $('.soc_'+el.data('soc')).closest('.input-container').removeClass('success')
        $('.soc_'+el.data('soc')).closest('.input-container').addClass('error')

  $(document).on 'click', '.del_your_cv', (event) ->
    event.preventDefault()
    el = $(this)
    $.post "/profiles/del_your_cv", (data) ->
      el.closest('.uploader_single').find('.uploader').removeClass('hidden')
      el.closest('.uploader_single').find('.uploader_true').addClass('hidden')

  $(document).on 'click', '.del_any_first', (event) ->
    event.preventDefault()
    el = $(this)
    $.post "/profiles/del_any_first", (data) ->
      el.closest('.uploader_single').find('.uploader').removeClass('hidden')
      el.closest('.uploader_single').find('.uploader_true').addClass('hidden')

  $(document).on 'click', '.del_any_second', (event) ->
    event.preventDefault()
    el = $(this)
    $.post "/profiles/del_any_second", (data) ->
      el.closest('.uploader_single').find('.uploader').removeClass('hidden')
      el.closest('.uploader_single').find('.uploader_true').addClass('hidden')


  $(document).on 'click', '.load_user_achivment_next', (event) ->
    event.preventDefault()
    el = $(this)
    $.getJSON "/user_achivments/get_slide", {per_page: $(this).closest('.user_achivments').data('perpage'), page: $(this).data('page'), user_id: $(this).closest('.user_achivments').data('user')}, (data) ->
      el.closest('.user_achivments_body').html(data['slide'])

  $(document).on 'click', '.rate-bar .star-item', (event) ->
    $(this).parents('.rate-bar').find('.star-item').removeClass('active')
    index =  $(this).parents('.rate-bar').find('.star-item').index($(this))
    $(this).parents('.rate-bar').find('input.ratings').val(index+1)
    x = 0
    while x <= index
      $(this).parents('.rate-bar').find('.star-item').eq(x).addClass('active')
      x = x+1

  
  create_message = (form) ->
    form = $(form).closest('form')
    ajax_sendform form, $(this), 'POST', 'message', ['description'],
      success: (data,status,xhr) ->
        if data['status'] == 'success'
          clear_form(form)
          form.closest('.chat-block').find('.chat_body .mCSB_container').append(data['messages'])
          $('.chat-block .chat-area').mCustomScrollbar("scrollTo", "#message-"+data['message_id'])
        else
          print_valid_errors('user_auth', data['errors'])
        set_sent_request(true)
      error: (xhr,status,error) ->
        message_error_ajax()

  $(document).on 'click', '.create_message', (event) ->
    event.preventDefault()
    create_message(this)

  $(document).on 'keypress', '.input-container-chat', (event) ->
    if(event.which == 10 || event.which == 13) 
      event.preventDefault()
      create_message(this)

  
  $(document).on 'change', '.sent_files_to_chat', (event) ->
    event.preventDefault()
    form = $(this).closest('form')
    ajax_sendform form, $(this), 'POST', '', [],
      success: (data,status,xhr) ->
        if data['status'] == 'success'
          clear_form(form)
          form.closest('.chat-block').find('.chat_body .mCSB_container').append(data['messages'])
          $('.chat-block .chat-area').mCustomScrollbar("scrollTo", "#message-"+data['message_id'])
        else
          print_valid_errors('user_auth', data['errors'])
        set_sent_request(true)
      error: (xhr,status,error) ->
        message_error_ajax()

  $('#sign_up_modal .social a').click (event) ->
    event.preventDefault()
    a_class = $(this).attr('class')
    if $(this).parents('#sign_up_modal').find("input[name='user[role_kind]']:checked").val() == 'client'
      $('#uLogin-1').find('.ulogin-button-'+a_class).click()
    else
      $('#uLogin-2').find('.ulogin-button-'+a_class).click()

  $('#log_in_modal .social a').click (event) ->
    event.preventDefault()
    a_class = $(this).attr('class')
    $('#uLogin-3').find('.ulogin-button-'+a_class).click()


  update_messages_count = ->
    $.getJSON "/messages/message_count", (data) ->
      $('.messages_count_icon').html(data['messages_html'])
      window.setTimeout(update_messages_count, 10000)
  update_messages_count()


  update_notifications = ->
    $.getJSON "/notifications/get_notification_list", (data) ->
      $('.user-logged .notifications-list').html(data['notifications'])
      if data['notifications_count'] > 0
        unless $('.notification-button').hasClass('open')
          $('.notification-button').addClass('open')
      window.setTimeout(update_notifications, 10000)
  update_notifications()  

  $('.notification-button').on 'hide.bs.dropdown', ->
    $.getJSON "/notifications/send_read_all", (data) ->
    return