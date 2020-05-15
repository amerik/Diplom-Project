//= require lib/jquery.mask

root = exports ? this


$(document).ready ->
  $('.date_with_year').mask('00.00.0000');

  $('.progress_bar').ready ->
    image = $('.bar-stripped')
    x = 0
    setInterval (->
      image.css 'background-position', x + 'px 0'
      x++
      return
    ), 20
    return
    
  $('.chat-block .chat-area').mCustomScrollbar
    axis: "y"
    theme: "dark"
    scrollTo: "bottom"
    callbacks:{
      onInit: ->
        $('.chat-block .chat-area').mCustomScrollbar("scrollTo", "bottom", {scrollInertia:0})
    }
    
  $(document).on 'click', '.user_cabinet .question-block .question a', (event) ->
    event.preventDefault()
    unless $(this).parents('.question-item').hasClass('active')
      $(this).parents('.question-block').find('.question-item').removeClass('active')
      $(this).parents('.question-item').addClass('active')


  $('.user_profile-block .choice-wrapper').mCustomScrollbar
    axis: "y"
    theme: "dark"
  

  $('#order_modal .modal-dialog .order-modal-body .lessons').mCustomScrollbar
    axis: "y"
    theme: "dark"  

  $('.notifications-block .notifications-block-body .info-wrapper').mCustomScrollbar
    axis: "y"
    theme: "dark" 


  $('.search-page-help').click (event)->
    event.preventDefault()
    form = $(this).closest('form')
    ajax_sendform form, $(this), 'POST', '', [],
      success: (data,status,xhr) ->
        if data['status'] == 'success'
          $('.category-block ul>li> a').removeClass('active')
          $('.answers_body').html(data['page_helps'])
        set_sent_request(true)
      error: (xhr,status,error) ->
        message_error_ajax()

  $('.search-area').keypress (event) ->
    if(event.which == 13)
      event.preventDefault()
      $('.search-page-help').click()


    


  $('.set_image').change (event) ->
    event.preventDefault()
    $('.image_upload').addClass('loading')
    $('.user-logged .avatar .loading').show()
    root.is_sent_request = true
    form_data = new FormData()
    form_data.append('image', $('.set_image')[0].files[0])
    multipart_ajax_request "/profiles/set_image", 'POST', form_data,
      success: (data,status,xhr) ->
        $('.image_area img').attr('src', data['image'])
        $('.user-logged .avatar img').attr('src', data['image'])
        $('.image_upload').removeClass('loading')
        $('.user-logged .avatar .loading').hide()
      error: (xhr,status,error) ->
        message_error($('#error_text').attr('value'))        