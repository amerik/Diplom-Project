update_tasks_notes = ->
  $.getJSON "/schedules/"+$('#room').attr('value')+"/update_tasks_notes_last", (data) ->
    $('.tasks_body').html(data['tasks'])
    # $('.chat-block .chat-area').mCustomScrollbar("scrollTo", "#message-"+last_id)
    $('.notes_body').html(data['notes'])
    # $('.chat-block .chat-area').mCustomScrollbar("scrollTo", "#message-"+last_id)
    window.setTimeout(update_tasks_notes, 10000)

check_end_lesson = ->
  $.getJSON "/schedules/"+$('#room').attr('value')+"/check_end_lesson", (data) ->
    if data['reload'] == 'true'
      location.reload()
    else
      window.setTimeout(check_end_lesson, 60000)

$(document).ready ->

  if $('#user_chat_update').attr('value') == 'true'
    update_tasks_notes()

  
  if $('#videos_page').attr('value') == 'current'
    check_end_lesson()

  $('.chat-block .chat-area').mCustomScrollbar
    axis: "y"
    theme: "dark"
    callbacks:{
      onInit: ->
        $('.chat-block .chat-area').mCustomScrollbar("scrollTo", "bottom", {scrollInertia:0})
    }

  $('.notes-block .notes-body').mCustomScrollbar
    axis: "y"
    theme: "dark"
    callbacks:{
      onInit: ->
        $('.chat-block .chat-area').mCustomScrollbar("scrollTo", "bottom", {scrollInertia:0})
    }

  $('.tasks-block .tasks-body').mCustomScrollbar
    axis: "y"
    theme: "dark"
    callbacks:{
      onInit: ->
        $('.chat-block .chat-area').mCustomScrollbar("scrollTo", "bottom", {scrollInertia:0})
    }
        
  $(document).on 'click', '.vid-button.resize', (event) ->
    $(this).parents('.video-chat-block').toggleClass('full')

  $(document).on 'click', '.video-call-block .chat.option-buttons', (event) ->
    $(this).parent().toggleClass('chat-active')
    $('.chat-block').toggle()

  $(document).on 'click', '.function-button.plus-button', (event) ->
    $(this).parents('.block-show-hide').toggleClass('active')

  x =0 
  setInterval (->
    x++
    if x <= 5
      $('.video-call-block .video-establishing-container .establishing-text span').append('.')
    else
      $('.video-call-block .video-establishing-container .establishing-text span').empty()
      x = 0
  ), 500


  $(document).on 'click', '.video_link', (event) ->
    event.preventDefault()
    $('.video-history-block .tone').show()
    $('.function-button.play').show()
    video_player = document.getElementsByTagName('video')[0]
    video_player.src = $(this).data('file')
    $('.lesson-history').html($(this).data('history'))
  
  $(document).on 'click', '.function-button.play', (event) ->
    $('.video-history-block .tone').hide()
    $('.video-js .vjs-big-play-button').click()
    $(this).hide()

  $('.add_task').click (event) ->
    event.preventDefault()
    $('#add_task').modal('show')

  $('.create_task').click (event) ->
    event.preventDefault()
    form = $(this).closest('form')
    ajax_sendform form, $(this), 'POST', 'task', ['description', 'achivment_id'],
      success: (data,status,xhr) ->
        if data['status'] == 'success'
          $('.tasks_body').prepend(data['task'])
          $('#add_task').modal('hide')
          clear_form(form)
        else
          print_valid_errors(data['entity'], data['errors'])
        set_sent_request(true)
      error: (xhr,status,error) ->
        message_error_ajax()

  $('.add_note').click (event) ->
    event.preventDefault()
    $('#add_note').modal('show')

  $('.create_note').click (event) ->
    event.preventDefault()
    form = $(this).closest('form')
    ajax_sendform form, $(this), 'POST', 'note', ['description', 'name'],
      success: (data,status,xhr) ->
        if data['status'] == 'success'
          $('.notes_body').prepend(data['note'])
          $('#add_note').modal('hide')
          clear_form(form)
        else
          print_valid_errors(data['entity'], data['errors'])
        set_sent_request(true)
      error: (xhr,status,error) ->
        message_error_ajax()

  $(document).on 'click', '.edit_task', (event) ->
    event.preventDefault()
    $.getJSON "/tasks/"+$(this).closest('.task_item').data('id')+"/get_form_edit", (data) ->
      $('.task_data_body').html(data['form_edit'])
      $('#edit_task').modal('show')

  $(document).on 'click', '.update_task', (event) ->
    event.preventDefault()
    form = $(this).closest('form')
    ajax_sendform form, $(this), 'PUT', 'task', ['description', 'achivment_id'],
      success: (data,status,xhr) ->
        if data['status'] == 'success'
          $('.tasks_body').html(data['task'])
          $('#edit_task').modal('hide')
          clear_form(form)
        else
          print_valid_errors(data['entity'], data['errors'])
        set_sent_request(true)
      error: (xhr,status,error) ->
        message_error_ajax()

  $(document).on 'click', '.edit_note', (event) ->
    event.preventDefault()
    $.getJSON "/notes/"+$(this).closest('.note_item').data('id')+"/get_form_edit", (data) ->
      $('.note_data_body').html(data['form_edit'])
      $('#edit_note').modal('show')

  $(document).on 'click', '.update_note', (event) ->
    event.preventDefault()
    form = $(this).closest('form')
    ajax_sendform form, $(this), 'PUT', 'note', ['description', 'achivment_id'],
      success: (data,status,xhr) ->
        if data['status'] == 'success'
          $('.notes_body').html(data['note'])
          $('#edit_note').modal('hide')
          clear_form(form)
        else
          print_valid_errors(data['entity'], data['errors'])
        set_sent_request(true)
      error: (xhr,status,error) ->
        message_error_ajax()

  $(document).on 'click', '.del_task', (event) ->
    event.preventDefault()
    el = $(this)
    modal_confirm $('#del_read').attr('value'), "Yes", "No", ->
      $.ajax '/tasks/'+el.closest('li').data('id'),
        type: 'DELETE'
        error: (jqXHR, textStatus, errorThrown) ->
          message_error("System error")
        success: (data, textStatus, jqXHR) ->
          el.closest('li').remove()

  $(document).on 'click', '.del_note', (event) ->
    event.preventDefault()
    el = $(this)
    modal_confirm $('#del_read').attr('value'), "Yes", "No", ->
      $.ajax '/notes/'+el.closest('li').data('id'),
        type: 'DELETE'
        error: (jqXHR, textStatus, errorThrown) ->
          message_error("System error")
        success: (data, textStatus, jqXHR) ->
          el.closest('li').remove()


  $(document).on 'click', '.load_videos_next', (event) ->
    event.preventDefault()
    el = $(this)
    $.getJSON "/videos/get_slide", {per_page: $('.video_items_container').data('perpage'), page: $(this).data('page'), has_created_at_min: $('#video_start_date').val(), has_created_at_max: $('#video_end_date').val()}, (data) ->
      el.closest('.videos_body').html(data['slide'])          


  $('.end-date').datetimepicker
    lang: "en",
    timepicker: false,
    datepicker: true,
    format: 'd/m/Y',
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

      $.getJSON "/videos/get_slide", {per_page: $('.video_items_container').data('perpage'), has_created_at_min: $('#video_start_date').val(), has_created_at_max: $('#video_end_date').val()}, (data) ->
        $('.videos_body').html(data['slide'])   


  $('.start-date').datetimepicker
    lang: "en",
    timepicker: false,
    datepicker: true,
    format: 'd/m/Y',
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

      $.getJSON "/videos/get_slide", {per_page: $('.video_items_container').data('perpage'), has_created_at_min: $('#video_start_date').val(), has_created_at_max: $('#video_end_date').val()}, (data) ->
        $('.videos_body').html(data['slide'])           