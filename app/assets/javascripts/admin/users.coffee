$(document).ready ->

  $('.set_mentor_for_user').click (event)->
    event.preventDefault()
    $.post "/admin/appoints", {appoint: {user_id: $('#student_id').attr('value'), mentor_id: $(this).data('id')}}, (data) ->
      window.location.href = "/admin/users"