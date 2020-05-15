//= require lib/ajax_submit


window.destroy_attachment = (attachment_url, callbacks)->
  callbacks ||= {}
  ajax_request(attachment_url, 'DELETE', '',
    success: (data, textStatus, xhr)->
      alert('Файл успешно удален')
      if($('ul.list_of_attachments li').length<=1)
        $('.att_files_ok').css('display','none')
      success_handler = callbacks['success'] || ->{}
      success_handler(data, textStatus, xhr)
    error: (xhr, textStatus, error)->
      alert('Не удалось удалить файл')
      error_handler = callbacks['error'] || ->{}
      error_handler(xhr, textStatus, error)
  )

window.send_file = (form, callbacks)->
  callbacks ||= {}
  file_field = form.find('input[type=file]')
  if file_field.get(0).files.length == 0
    return false
  multipart_ajax_sendform(form, 'POST',
    success: (data, textStatus, xhr)->
      #alert('Файл загружен')
      form.get(0).reset()
      file_field.change()
      success_handler = callbacks['success'] || ->{}
      success_handler(data, textStatus, xhr)
    error: (xhr, textStatus, error)->
      alert('Не удалось загрузить файл')
      error_handler = callbacks['error'] || ->{}
      error_handler(xhr, textStatus, error)
  )
