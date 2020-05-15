root = exports ? this
root.is_sent_request = true

window.set_sent_request = (is_val) ->
  root.is_sent_request = is_val
  if is_val == true
    $('.loading').removeClass('loading')

# method: 'GET' or 'POST' or 'PUT' or 'DELETE'
window.ajax_request = (url, button, method, data, callbacks) ->
  if !button.hasClass('loading')
    button.addClass('loading')
    form_data = new FormData()
    $.each data, (i, v) ->
      form_data.append(i, v)
    multipart_ajax_request(url, method, form_data, callbacks)

window.ajax_sendform = (form_selector, button, method, entity, fields_valid, callbacks) ->
  is_true = true
  for tag in fields_valid
    do ->
      if form_selector.find('#'+entity+'_'+tag).attr('type') == 'text'
        if form_selector.find('#'+entity+'_'+tag).val() == ""
          form_selector.find('#'+entity+'_'+tag).closest('.input-container').addClass('error')
          form_selector.find('#'+entity+'_'+tag).closest('.calendar-container').addClass('error')
          is_true = false
      else if form_selector.find('#'+entity+'_'+tag).prop("tagName") == 'TEXTAREA'
        if form_selector.find('#'+entity+'_'+tag).val() == ""
          form_selector.find('#'+entity+'_'+tag).closest('.textarea-container').addClass('error')
      else if form_selector.find('#'+entity+'_'+tag).hasClass('select_value')
        if form_selector.find('#'+entity+'_'+tag).val() == "" || form_selector.find('#'+entity+'_'+tag).val() == undefined
          form_selector.find('#'+entity+'_'+tag).closest('.dropdown-container').addClass('error')
          is_true = false
      else if form_selector.find('#'+entity+'_'+tag).attr('type') == 'file'
        if form_selector.find('#'+entity+'_'+tag)[0].files.length == 0 && form_selector.find('#'+entity+'_'+tag).hasClass('is_file_false')
          form_selector.find('#'+entity+'_'+tag).closest('.file-container').addClass('error')
          is_true = false
  if is_true && !button.hasClass('loading')
    button.addClass('loading')
    form_selector.append('<input type="hidden" name="hash_auto_fill" value="'+$('#hash_auto_fill').attr('value')+'">')
    multipart_ajax_sendform(form_selector, method, callbacks)

# all requests made this way are multipart
window.multipart_ajax_request = (url, method, data, callbacks) ->
  if root.is_sent_request
    set_sent_request(false)
    callbacks ||= {}
    console.info(data)
    $.ajax
      url: url
      dataType: 'json'
      contentType: false
      processData: false
      data: data
      type: method
      success: callbacks['success'] || (data, textStatus, xhr) -> {}
      error: callbacks['error'] || (xhr, textStatus, error) -> {}

window.multipart_ajax_sendform = (form_selector, method, callbacks) ->
  $(form_selector).each (idx, form)->
    if window.FormData != undefined
      multipart_ajax_request(form.action, method, new FormData(form), callbacks)
    else
      multipart_ajax_request(form.action, method, $(form).serialize(), callbacks)

window.make_ajax_get = (ajaxUrl, functionSuccess, functionFailure) ->
  if root.is_sent_request
    set_sent_request(false)
    $.ajax({
      type: "GET",
      url: ajaxUrl,
      contentType: "application/json; charset=utf-8",
      data: {},
      dataType: "json",
      success: functionSuccess,
      error: functionFailure
    })

window.makeAjaxDestroy = (ajaxUrl, dataHash, functionSuccess, functionFailure) ->
  if root.is_sent_request
    set_sent_request(false)
    $.ajax({
      type: "DELETE",
      url: ajaxUrl,
      contentType: "application/json; charset=utf-8",
      data: dataHash,
      dataType: "json",
      success: functionSuccess,
      error: functionFailure
    })

window.makeAjaxPost = (ajaxUrl, dataHash, functionSuccess, functionFailure) ->
  if root.is_sent_request
    set_sent_request(false)
    $.ajax
      type: "POST",
      url: ajaxUrl,
      #contentType: "application/json; charset=utf-8",
      data: $.param(dataHash),
      dataType: "json",
      processData: false,
      success: functionSuccess,
      error: functionFailure