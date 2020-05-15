window.calc_baskets = () ->
  count = 0
  $.each $('.baskets_body').find('.num_basket'), (i, v) ->
    $(v).text('№'+(i+1))
    count += 1
  if count > 0
    $('.count_baskets').text(count)
    $('.show_order').show()
  else
    $('.show_order').hide()


$(document).ready ->
  if parseInt($('.show_order .count_baskets').html()) > 0
    $('.show_order').show()

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
    
  $('.my-mentor-block .choice-wrapper').mCustomScrollbar
    axis: "y"
    theme: "dark"

    
  $(document).on 'click', '.set_date_shedule', (event) ->
    event.preventDefault()
    el = $(this)
    if !el.hasClass('old_day')
      ajax_request "/schedules/reading_mentor", el, 'POST', {year: $(this).data('year'), month: $(this).data('month'), day: $(this).data('day'), hour: $(this).data('hour')},
        success: (data,status,xhr) ->
          if data['status'] == 'success'
            if data['shedule_day'] == 'new'
              el.addClass('active')
            else
              el.removeClass('active')
          else
            print_valid_errors('user', data['errors'])
          set_sent_request(true)
        error: (xhr,status,error) ->
          message_error_ajax()

  $(document).on 'click', '.calendar_lesions_student .item .availability', (event) ->       
    unless $(this).parent().find('.tool-tip').hasClass('active')
      $('.calendar_lesions_student').find('.tool-tip').removeClass('active')
      $(this).parent().find('.tool-tip').addClass('active')

  $(document).on 'click', '.calendar_lesions_student .item .tool-tip .close', (event) ->
    $(this).parents('.tool-tip').removeClass('active')


  $('.show_order').click (event) ->
    event.preventDefault()
    $('#order_modal').modal('show')

  $(document).on 'click', '.create_basket', (event) ->
    event.preventDefault()
    form = $(this).closest('form')
    item = $(this).closest('.day_item_body')
    ajax_sendform form, $(this), 'POST', '', [],
      success: (data,status,xhr) ->
        if data['status'] == 'success'
          $('.baskets_body').append(data['basket'])
          item.html(data['item_day'])
          calc_baskets()
        set_sent_request(true)
      error: (xhr,status,error) ->
        message_error_ajax()

  $(document).on 'click', '.del_basket', (event) ->
    event.preventDefault()
    el = $(this)
    basket_item = el.closest('.basket_item')
    ajax_request "/baskets/"+$(this).data('id'), el, 'DELETE', {year: basket_item.data('year'), month: basket_item.data('month'), day: basket_item.data('day')},
      success: (data,status,xhr) ->
        if data['status'] == 'success'
          el.closest('.basket_item').remove()
          $('.day_item_body_'+basket_item.data('year')+'_'+basket_item.data('month')+'_'+basket_item.data('day')).html(data['item_day'])
          calc_baskets()
        set_sent_request(true)
      error: (xhr,status,error) ->
        message_error_ajax()

  $('.del_all_new_baskets').click (event) ->
    event.preventDefault()
    $.post "/baskets/del_all_new_baskets", (data) ->
      location.reload()

  $('.set_user_for_schedules').click (event) ->
    event.preventDefault()
    $.post "/schedules/set_user", (data) ->
      location.reload()

  $('.search_mentor').click (event) ->
    event.preventDefault()    
    $.post "/users/request_mentor", (data) ->
      $('.mentor_status_body').html(data['status_html'])
      $('.progress_bar').ready ->
        image = $('.bar-stripped')
        x = 0
        setInterval (->
          image.css 'background-position', x + 'px 0'
          x++
          return
        ), 20
        return      


  $('.change_mentor').click (event) ->
    el = $(this)
    modal_confirm "Are you sure you want to change mentor", "Yes", "No", ->
      $.post "/admin/appoints/change_mentor", {appoint: {user_id: el.data('id')}}, (data) ->
        location.reload()

