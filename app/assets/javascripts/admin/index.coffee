//= require admin/lib/jquery.mask

$(document).ready ->
  $('#phone').mask("(000)000-00-00", {placeholder: "(___)___-__-__"});

  $('.user_authorization').click (event) ->
    event.preventDefault()
    form = $(this).closest('form')
    if form.find('#user_login').val() == ""
    	form.find('#user_login').focus()
    else if form.find('#user_password').val() == ""
    	form.find('#user_password').focus()
    else
    	log_in_send_form($(this).closest('form'))

  $('.log_in_enter').keypress (event) ->
    if(event.which == 13)
      log_in_send_form($(this).closest('form'))

log_in_send_form = (form) ->
  ajax_sendform form, 'POST',
    success: (data,status,xhr) ->
      if_else_success_form form, data, ->
        window.location.href = data['url']
    error: (xhr,status,error) ->
      message_error("System error")