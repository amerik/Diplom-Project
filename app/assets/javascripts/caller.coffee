root = exports ? this
root.callback_confirm

window.video_call_block = () ->
  $.getJSON "/videos/video_call_block",{user_other: $('#user_other').val(), chat: $('#chat_block_id').val() }, (data) ->
    if data['status'] == "success"
      $('.video-call-container').html(data['video_html'])
      $('.chat-block .chat-area').mCustomScrollbar
        axis: "y"
        theme: "dark"
        callbacks:{
          onInit: ->
            $('.chat-block .chat-area').mCustomScrollbar("scrollTo", "bottom", {scrollInertia:0})
        }
      update_chat()

window.reset_call = () ->
  $.getJSON "/videos/call_hangup",{type: 'new'}, (data) ->
    if data['status'] == "success"
      video_room.CancelCall(data['room'])
      video_call_block()


$(document).ready ->
  call_timer = undefined
  call_status = undefined
  new_status = undefined

  video_call_block()

  check_is_call = () ->
    $.getJSON "/videos/check_is_call", (data) ->
      if data['status'] == "success"
        if data['user_has_call'] == true
          $('#make_call').hide()
          $('#answer_to_call').show()
          $('#call_hangup').addClass('right')
          $('#call_hangup').show()

      else
        alert('error !')


  get_call_status = () ->
    $.getJSON "/videos/get_call_status", (data) ->
      if data['status'] == "success"
        #console.log(data['call_status'])
        if data['call_status'] == 'calling'
          call_status = 'calling'
          check_is_call()
        else if data['call_status'] == 'accepted'
          call_status = 'accepted'
          $('#call_config').val(data['file'])
        else if data['call_status'] == 'canceled'
          call_status = 'canceled'
        else
          call_status = 'new'
          #video_call_block()
      else
        alert('error !')
    if new_status != call_status && new_status != undefined
      console.log(call_status)
      if call_status == 'new'
        $('.video-establishing-container').hide()
        $('.video-ready-to-call-container').show()        
        $('#call_hangup').hide()
        $('#answer_to_call').hide()
        $('#make_call').show()
        $('.call-function-button').removeClass('disable')
      else if call_status == 'calling'
        $('.video-ready-to-call-container').hide()
        $('.video-establishing-container').show()
        $('#make_call').hide()
        $('.caller #call_hangup').show()      
      else if call_status == 'accepted'
        $('#make_call').hide()
        $('#call_hangup').show()
        AttachJanus()
        $('.video-establishing-container').hide()
        $('.remote-stream-container').show() 
        $('.microphone.option-buttons').removeClass('hide')
        $('.screen-share.option-buttons').removeClass('hide')
      else if call_status == 'canceled'
        $('.video-establishing-container').hide()
        $('.video-ready-to-call-container').show()        
        $('#call_hangup').hide()
        $('#answer_to_call').hide()
        $('#make_call').show()  
        $('#call_hangup').removeClass('right') 
        $('.microphone.option-buttons').addClass('hide')   
        $('.screen-share.option-buttons').addClass('hide')
    new_status = call_status


  $(document).on 'click', '#make_call', (event) ->
    $(this).addClass('disable')
    $('.video-call-block').addClass('caller')
    $.getJSON "/videos/make_call", (data) ->
      if data['status'] == "success"
        console.log('making new call..')      
      else
        if (confirm(data['msg']) == true) 
          $('#call_hangup').click()
        else
          $(this).removeClass('disable')
          return false


  $(document).on 'click', '#call_hangup', (event) ->
    $(this).addClass('disable')
    $('#answer_to_call').addClass('disable')
    $('.video-call-block').removeClass('caller')
    $.getJSON "/videos/call_hangup",{type: 'cancel'}, (data) ->
      if data['status'] == "success"
        setTimeout (->
          reset_call()
          return
        ), 2000         
      else
        alert(data['msg'])


  $(document).on 'click', '#answer_to_call', (event) ->
    $(this).hide()
    $('#call_hangup').removeClass('right')
    $.getJSON "/videos/answer_to_call", (data) ->
      if data['status'] == "success"
        $('#make_call').hide()
        $('#call_hangup').show() 
      else
        alert(data['msg'])  
        #windowReloadUnBind()
        video_call_block()


  timer_start = () ->
    call_timer = setInterval(get_call_status, 1000)
  

  timer_start()