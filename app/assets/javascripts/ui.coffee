$(document).ready ->
  
  ####input/textarea
  $('.ui input, .ui textarea').focus(->
    ##$(this).parent('div').addClass('focus')
    unless $(this).parents('.ui').hasClass('disabled')
      $(this).parent('div').addClass('focus')
    else
      $(this).prop( "disabled", true )
    return
  ).blur ->
    $(this).parent('div').removeClass('focus')
    return

  ####dropdown
  # $('.ui.dropdown:not(.disabled) input').focus(->
  #   $(this).parent().removeClass('menu-down')
  #   $(this).parent().addClass('menu-up')
  #   $(this).parent().find('.dropdown-trigger').removeClass('arrowdown')
  #   $(this).parent().find('.dropdown-trigger').addClass('arrowtop')
  #   return
  # ).blur ->
  #   $(this).parent().removeClass('menu-up')
  #   $(this).parent().addClass('menu-down')
  #   $(this).parent().find('.dropdown-trigger').removeClass('arrowtop')
  #   $(this).parent().find('.dropdown-trigger').addClass('arrowdown')
  #   return

  $(document).click (event) ->
    if event.button == 0
      $('.ui.dropdown').find('.dropdown-container').removeClass('menu-up')
      $('.ui.dropdown').find('.dropdown-container').addClass('menu-down')
      $('.ui.dropdown').find('.dropdown-trigger').removeClass('arrowtop')
      $('.ui.dropdown').find('.dropdown-trigger').addClass('arrowdown')

  $(document).on 'click', '.ui.dropdown .select_val', (event) ->
    event.stopPropagation()
    $(this).closest('.dropdown-container').removeClass('menu-down')
    $(this).closest('.dropdown-container').addClass('menu-up')
    $(this).closest('.dropdown-container').find('.dropdown-trigger').removeClass('arrowdown')
    $(this).closest('.dropdown-container').find('.dropdown-trigger').addClass('arrowtop')
    $(this).closest('.dropdown-container').removeClass('error')

  $(document).on 'click', '.ui.dropdown ul li', (event) ->
    event.preventDefault()
    $(this).closest('.ui.dropdown').find('.select_val').val($(this).text())
    $(this).closest('.ui.dropdown').find('.select_value').attr('value', $(this).data('id'))
    $(this).closest('.ui.dropdown').find('.dropdown-container').removeClass('menu-up')
    $(this).closest('.ui.dropdown').find('.dropdown-container').addClass('menu-down')
    $(this).closest('.ui.dropdown').find('.dropdown-trigger').removeClass('arrowtop')
    $(this).closest('.ui.dropdown').find('.dropdown-trigger').addClass('arrowdown')

  $(document).on 'keyup', '.change_value', (event) ->
    event.preventDefault()

    $.getJSON "/countries/find_country", {country_text: $(this).val()}, (data) ->
      if parseInt(data['count_countries']) > 0
        $('.country_elements_list').html(data['countries'])
        


  ####calendar
  $('.ui.calendar:not(.disabled) input').focus(->
    $(this).parent().find('.calendar-trigger').removeClass('arrowdown')
    $(this).parent().find('.calendar-trigger').addClass('arrowtop')
    return
  ).blur ->
    $(this).parent().find('.calendar-trigger').removeClass('arrowtop')
    $(this).parent().find('.calendar-trigger').addClass('arrowdown')
    return

  ####checkbox
  $('.ui.checkbox:not(.disabled)').click ->
    if $(this).find('.checkbox-container').hasClass('checked')
      $(this).find('.checkbox-container').removeClass('checked')
      $(this).find('checkbox').prop("checked", false)
    else
      $(this).find('.checkbox-container').addClass('checked')
      $(this).find('checkbox').prop("checked", true)

  ####radio
  $('.ui.radio:not(.disabled)').click ->
    unless $(this).find('.radio-container').hasClass('checked')
      $(this).parents('.radio-area').find('.ui.radio:not(.disabled)').find('.radio-container').removeClass('checked')
      $(this).parents('.radio-area').find('.ui.radio:not(.disabled)').find('input[type=radio]').prop("checked", false)
      $(this).parents('.radio-area').find('.ui.radio:not(.disabled)').find('input[type=checkbox]').prop("checked", false)

      $(this).find('.radio-container').addClass('checked')
      $(this).find('input[type=radio]').prop("checked", true)
      $(this).find('input[type=checkbox]').prop("checked", true)

  $('.ui.single_uploader input').change (event) ->
    event.preventDefault()
    $(this).closest('.uploader').addClass('hidden')
    uploader_true = $(this).closest('.uploader_single').removeClass('error')
    uploader_true = $(this).closest('.uploader_single').find('.uploader_true')
    uploader_true.removeClass('hidden')
    uploader_true.find('.name').text($(this).val().replace(/C:\\fakepath\\/i, ''))
    uploader_true.find('.size').text('('+($(this)[0].files[0].size / 1000000).toFixed(2)+' mb)')

  $(document).on 'click', '.uploader_single .clear_file', (event) ->
    event.preventDefault()
    $(this).closest('.uploader_single').find('.uploader').removeClass('hidden')
    $(this).closest('.uploader_single').find('.uploader_true').addClass('hidden')

  $('.ui.many_uploader input').change (event) ->
    event.preventDefault()
    $(this).closest('.uploader').addClass('hidden')
    uploader_true = $(this).closest('.uploader_many').find('.uploader_true')
    uploader_true.removeClass('hidden')
    el = $(this)

    for file in $(this)[0].files
      do ->
        el.closest('.uploader_many').find('.file-loading-container').append('<div class="file-item">
          <div class="name" title="File name">'+file.name+'</div>
          <div class="size">('+(file.size / 1000000).toFixed(2)+' mb)</div>
          <div class="remove clear_file_from_files"></div>
          </div>')

  $(document).on 'click', '.uploader_many .clear_file_from_files', (event) ->
    event.preventDefault()
    # $(this).closest('.file-item').remove()
    # arr = $('.clear_file_from_files').closest('.uploader_many').find('input[type=file]')[0].files
    # arr.filter(word)

    $(this).closest('.uploader_many').find('.uploader').removeClass('hidden')
    $(this).closest('.uploader_many').find('.uploader_true').addClass('hidden')
    $(this).closest('.uploader_many').find('.file-loading-container').html('')