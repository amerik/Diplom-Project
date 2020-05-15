window.set_stage = (stage, old_stage) ->
  $('.progress_bar').find('.item').removeClass('stage-reached')
  $('.stage-'+(old_stage)).addClass('hidden')
  $('.stage-'+stage).removeClass('hidden')
  $('.item_stage_'+stage).addClass('on-stage')
  if stage < old_stage
    $('.item_stage_'+old_stage).removeClass('on-stage')
  if stage == 2
    $('.item_stage_1').addClass('stage-reached')
  if stage == 3
    $('.item_stage_1').addClass('stage-reached')
    $('.item_stage_2').addClass('stage-reached')

$(document).ready ->

  $('.save_role_kind').click (event)->
    event.preventDefault()
    form = $(this).closest('form')
    ajax_sendform form, $(this), 'POST', 'user', ['role_kind'],
      success: (data,status,xhr) ->
        if data['status'] == 'success'
          window.location.href = data['url']
        else
          print_valid_errors('user', data['errors'])
      error: (xhr,status,error) ->
        message_error_ajax()


  $('.save_stage_1').click (event)->
    event.preventDefault()
    form = $(this).closest('form')
    ajax_sendform form, $(this), 'POST', 'profile', ['last_name', 'first_name', 'birth_at', 'university_id', 'year_of_study', 'sex', 'city_id', 'degree'],
      success: (data,status,xhr) ->
        if data['status'] == 'success'
          set_stage(2, 1)
        else
          print_valid_errors('profile', data['errors'])
        set_sent_request(true)
      error: (xhr,status,error) ->
        message_error_ajax()

  $('.save_stage_2').click (event)->
    event.preventDefault()
    form = $(this).closest('form')
    is_valud = true
    $.each $('.specializations_body').find('input[type=text]'), (i, v) ->
      if $(v).val() == ""
        $(v).closest('.input-container').addClass('error')
        is_valud = false
        true
    if is_valud
      ajax_sendform form, $(this), 'POST', '', [],
        success: (data,status,xhr) ->
          if data['status'] == 'success'
            set_stage(3, 2)
          set_sent_request(true)
        error: (xhr,status,error) ->
          message_error_ajax()

  $('.save_stage_3').click (event)->
    event.preventDefault()
    form = $(this).closest('form')
    if $('.stages').data('role') == 'mentor'
      valids = ['your_cv']
    else
      valids = []
    ajax_sendform form, $(this), 'POST', 'profile', valids,
      success: (data,status,xhr) ->
        if data['status'] == 'success'
          window.location.href = '/users'
        else
          print_valid_errors('profile', data['errors'])
        set_sent_request(true)
      error: (xhr,status,error) ->
        message_error_ajax()

  $('.set_stage_back').click (event)->
    event.preventDefault()
    set_stage(parseInt($(this).data('stage')), parseInt($(this).data('oldstage')))