//= require admin/lib/SmoothScroll.min
//= require admin/lib/jquery.mCustomScrollbar.concat.min
//= require admin/lib/attachment_submit
//= require admin/lib/jquery.datetimepicker
//= require admin/common/yes_no_swich_list
//= require admin/common/multi_select

list_menu_size = () ->
  ul_height =  $(window).height()- (165)
  $('.left_menu>.list_menu').height(ul_height)
  $('.left_menu>.list_menu').mCustomScrollbar theme: 'inset-2'
  $('.data_content').css('min-height',$(window).height())

root = exports ? this
root.callback_confirm

root.CKupdate = ->
  CKEDITOR.instances[instance].updateElement() for instance of CKEDITOR.instances

root.if_else_success = (data, callback) ->
  if data['status'] == 'success' || data['status'] == 'true'
    callback()
  else
    message_error(data['status'])

root.if_else_success_form = (form, data, callback) ->
  if data['status'] == 'success' || data['status'] == 'true'
    callback()
  else
    form.find('.message_errors > ul').html('')
    str = ""
    $.each data['errors'], (i, v) ->
      str += '<li>'+v+'</li>';
    form.find('.message_errors > ul').html(str)
    form.find('.message_errors').css('display', 'block')

root.message_success = (text) ->
  $('.success_message').html(text)
  $('#success_modal').modal('show')

root.message_error = (text) ->
  $('.error_message').html(text)
  $('#error_modal').modal('show')

root.message_info = (text) ->
  $('.info_message').html(text)
  $('#info_modal').modal('show')

root.modal_confirm = (text, text_yes, text_no, callback) ->
  root.callback_confirm = callback
  $('#yes_no_modal').find('.description').html(text)
  $('#yes_no_modal').find('.yes').text(text_yes)
  $('#yes_no_modal').find('.no').text(text_no)
  $('#yes_no_modal').modal('show')

root.create_entity = (form, callback) ->
  form.find('.loading_button').css('display', 'block')
  form.find('.loading_button').next().css('display', 'none')
  ajax_sendform form, 'POST',
    success: (data,status,xhr) ->
      if data['status'] != "success"
        str = ""
        $.each data['errors'], (i, v) ->
          str += '<li>'+v+'</li>';
          form.find('.message_errors > ul').html(str)
        form.find('.message_errors').css('display', 'block')
        form.find('.loading_button').css('display', 'none')
        form.find('.loading_button').next().css('display', 'table')
      else
        if !callback
          window.location.href = data['url']
        else
          callback(data)
    error: (xhr,status,error) ->
      message_error($('#error_text').attr('value'))

root.update_entity = (form, callback) ->
  form.find('.loading_button').css('display', 'block')
  form.find('.loading_button').next().css('display', 'none')
  ajax_sendform form, 'PUT',
    success: (data,status,xhr) ->
      if data['status'] != "success"
        str = ""
        $.each data['errors'], (i, v) ->
          str += '<li>'+v+'</li>';
          form.find('.message_errors > ul').html(str)
        form.find('.message_errors').css('display', 'block')
        form.find('.loading_button').css('display', 'none')
        form.find('.loading_button').next().css('display', 'table')
      else
        if !callback
          window.location.href = data['url']
        else
          callback(data)
    error: (xhr,status,error) ->
      message_error($('#error_text').attr('value'))

$(document).ready ->
  # $('#enter_sms').modal('show')
  
  list_menu_size()
  $('.menu_activator').click ->
    $('body').toggleClass('left_menu_active')

  $('a.no-link').click (event)->
  	event.preventDefault()

  $('#yes_no_modal .yes').click (event) ->
    event.preventDefault()
    callback_confirm()
    $('#yes_no_modal').modal('hide')
  
  # $('.type_1_menu .left_menu ul.first>li').click ->
  #   unless $(this).hasClass('active')
  #     $(this).parents('ul.first').find('li').removeClass('active')
  #     $(this).addClass('active')
      
  #   unless $(this).find('a').hasClass('more_details')
  #     $('.content_wrapper').removeClass('active')
  #   else
  #     $('.content_wrapper').addClass('active')

  $('.search_entities').click (event)->
    event.preventDefault()
    $(this).closest('form').submit()

  $(document).on 'click', '.default_dropdown ul li', (event) ->
    event.preventDefault()
    $(this).closest('.default_dropdown').find('.text').html($(this).find('a').text())
    $(this).closest('.default_dropdown').find('.select_value').attr('value', $(this).data('id'))
    if $(this).hasClass('set_chat_show')
      $('.message_chat_id').attr('value', '')

  $(document).on 'click', '.functions .fast_edit_function', (event) ->
    event.preventDefault()
    tr = $(this).closest('tr')
    unless $(this).hasClass('save')
      $(this).addClass('save')
      tr.find('.normal').hide()
      tr.find('.fast_edit').show()
    else
      entity = {}
      $.each tr.find('.field_input'), (i, v) ->
        entity[$(v).attr('name')] = $(v).val()
      $.each tr.find('.select_value'), (i, v) ->
        entity[$(v).attr('name')] = $(v).val()        
      $.each tr.find('.field_select').find('.checkbox_value'), (i, v) ->
        console.info(i, $(v))
        entity[$(v).attr('name')] = $(v).attr('value')
      entity['partial'] = $(this).data('partial')
      $.post "/admin/"+$(this).data('entity')+"/"+$(this).data('id')+"/update_fast", entity, (data) ->
        if data['status'] == 'success'
          tr.html(data['entity_tr'])
        else
          str = ""
          $.each data['errors'], (i, v) ->
            str += '<li>'+v+'</li>';
          console.info(str)
          message_error('<ul>'+str+'</ul>')

  $(document).on 'click', '.functions .delete_function', (event) ->
    event.preventDefault()
    el = $(this)
    modal_confirm $('#del_read').attr('value'), "Yes", "No", ->
      $.ajax '/admin/'+el.data('entity')+'/'+el.data('id'),
        type: 'DELETE'
        error: (jqXHR, textStatus, errorThrown) ->
          message_error("System error")
        success: (data, textStatus, jqXHR) ->
          if el.closest('.functions').hasClass('del_row')
            el.closest('.row').remove()
          else
            el.closest('tr').remove()

  $(document).on 'click', '.default_checkbox_tr', (event) ->
    event.preventDefault()
    if $(this).hasClass('active')
      $(this).removeClass('active')
    else
      $(this).addClass('active')

  $(document).on 'click', '.default_checkbox_th', (event) ->
    event.preventDefault()
    if $(this).hasClass('active')
      $(this).closest('table').find('.default_checkbox_tr').removeClass('active')
      $(this).removeClass('active')
    else
      $(this).closest('table').find('.default_checkbox_tr').addClass('active')
      $(this).addClass('active')

  $('.del_checking_tr').click (event)->
    event.preventDefault()
    ids = {}
    el = $(this)
    $.each el.closest('.filters_block').next().find('.default_checkbox_tr'), (i, v) ->
      if $(v).hasClass('active')
        ids[i] = $(v).closest('tr').data('id')
    modal_confirm $('#del_read_all').attr('value'), "Yes", "No", ->
      $.ajax '/admin/'+el.data('entity')+'/destroy_checking',
        type: 'DELETE',
        dataType: "json",    
        data: {ids}
        error: (jqXHR, textStatus, errorThrown) ->
          message_error("System error")
        success: (data, textStatus, jqXHR) ->
          location.reload()

  $('.create_entity').click (event) ->
    event.preventDefault()
    create_entity($(this).closest('form'))

  $('.check_box_def').click (event) ->
    event.preventDefault()
    li = $(this).closest('li')
    if !$(this).hasClass('active')
      li.find('input').attr('value', 'true')
      $(this).addClass('active')
    else
      li.find('input').attr('value', 'fasle')
      $(this).removeClass('active')

  $('.create_entity_ck').click (event) ->
    event.preventDefault()
    CKupdate()
    create_entity($(this).closest('form'))

  $(document).on 'click', '.update_entity', (event) ->
    event.preventDefault()
    update_entity($(this).closest('form'))

  $(document).on 'click', '.update_entity_ck', (event) ->
    event.preventDefault()
    CKupdate()
    update_entity($(this).closest('form'))

  $('.time_field').datetimepicker
    lang: "en",
    timepicker: true,
    datepicker: false,
    format: 'H:i',
    scrollMonth : false,
    scrollInput : false,
    closeOnDateSelect: true
    onChangeDateTime: (dp, $input) ->
      $input.prev().val($input.val())

  $('.date_field').datetimepicker
    lang: "en",
    timepicker: false,
    format: 'Y-m-d',
    scrollMonth : false,
    scrollInput : false,
    closeOnDateSelect: true
    onChangeDateTime: (dp, $input) ->
      $input.prev().val($input.val())

  $('.date_field_no_old_dates').datetimepicker
    lang: "en",
    timepicker: false,
    format: 'Y-m-d',
    scrollMonth : false,
    scrollInput : false,
    minDate: new Date(),
    closeOnDateSelect: true
    onChangeDateTime: (dp, $input) ->
      $input.prev().val($input.val())

  $('.date_field2').datetimepicker
    lang: "en",
    timepicker: false,
    format: 'Y-m-d',
    scrollMonth : false,
    scrollInput : false,
    closeOnDateSelect: true
    onChangeDateTime: (dp, $input) ->
      $input.prev().val($input.val())

  $('.date_field2_no_old_dates').datetimepicker
    lang: "en",
    timepicker: false,
    format: 'Y-m-d',
    scrollMonth : false,
    scrollInput : false,
    minDate: new Date(),
    closeOnDateSelect: true
    onChangeDateTime: (dp, $input) ->
      $input.prev().val($input.val())

  $('.date_field3').datetimepicker
    lang: "en",
    timepicker: false,
    format: 'Y-m-d',
    scrollMonth : false,
    scrollInput : false,
    closeOnDateSelect: true
    onChangeDateTime: (dp, $input) ->
      $input.prev().val($input.val())

  $('.date_field4').datetimepicker
    lang: "en",
    timepicker: false,
    format: 'Y-m-d',
    scrollMonth : false,
    scrollInput : false,
    closeOnDateSelect: true
    onChangeDateTime: (dp, $input) ->
      $input.prev().val($input.val())

  $('.date_field5').datetimepicker
    lang: "en",
    timepicker: false,
    format: 'Y-m-d',
    scrollMonth : false,
    scrollInput : false,
    closeOnDateSelect: true
    onChangeDateTime: (dp, $input) ->
      $input.prev().val($input.val())

  $('.date_field6').datetimepicker
    lang: "en",
    timepicker: false,
    format: 'Y-m-d',
    scrollMonth : false,
    scrollInput : false,
    closeOnDateSelect: true
    onChangeDateTime: (dp, $input) ->
      $input.prev().val($input.val())

  $('.date_field_pre_start_at').datetimepicker
    lang: "en",
    timepicker: false,
    format: 'Y-m-d',
    scrollMonth : false,
    scrollInput : false,
    minDate: new Date(),
    closeOnDateSelect: true
    onChangeDateTime: (dp, $input) ->
      $input.prev().val($input.val())

  $('.date_field_pre_end_at').datetimepicker
    lang: "en",
    timepicker: false,
    format: 'Y-m-d',
    scrollMonth : false,
    scrollInput : false,
    minDate: new Date(),
    closeOnDateSelect: true
    onChangeDateTime: (dp, $input) ->
      $input.prev().val($input.val())

  $('.date_field_end_at').datetimepicker
    lang: "en",
    timepicker: false,
    format: 'Y-m-d',
    scrollMonth : false,
    scrollInput : false,
    minDate: new Date(),
    closeOnDateSelect: true
    onChangeDateTime: (dp, $input) ->
      $input.prev().val($input.val())

  $('.datetime_field_end_at').datetimepicker
    lang: "en",
    timepicker: true,
    format: 'd.m.Y H:i',
    scrollMonth : false,
    scrollInput : false,
    closeOnDateSelect: true
    onChangeDateTime: (dp, $input) ->
      $input.prev().val($input.val())

$(window).resize ->
  list_menu_size()