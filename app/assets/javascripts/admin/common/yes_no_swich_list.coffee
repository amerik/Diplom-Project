$(document).ready ->
  $(document).on 'click', '.yes_no_switch', (event) ->
    unless $(this).hasClass('set_visible') || $(this).hasClass('set_status_register')
      # unless $(this).parent().hasClass('active')
      #   $(this).parent().addClass('active')
      #   $(this).parent().find('.checkbox_value').attr('value', 'true')
      # else
      #   $(this).parent().removeClass('active')
      #   $(this).parent().find('.checkbox_value').attr('value', 'false')

      unless $(this).hasClass('active')
        $(this).addClass('active')
        $(this).find('.checkbox_value').attr('value', 'true')
      else
        $(this).removeClass('active')
        $(this).find('.checkbox_value').attr('value', 'false')