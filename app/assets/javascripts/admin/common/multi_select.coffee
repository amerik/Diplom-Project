$(document).ready ->
  $(document).on 'click', '.dropdown_area .dropdown-menu a', (event) ->
    event.preventDefault()
    $(this).parents('.dropdown_area').find('.placeholder').remove()
    html = '<li><a href="#" id="'+$(this).attr('id')+'">'+$(this).text()+'<div class="remove"></div></a></li>'
    $(this).parents('.dropdown_area').find('.selected_items').find('ul').append(html)
    $(this).parent('li').remove()


  $(document).on 'click', '.dropdown_area .selected_items a .remove', (event) ->
    event.preventDefault()
    html = '<li><a href="#" id="'+$(this).parent().attr('id')+'">'+$(this).parent().text()+'</a></li>'
    $(this).parents('.dropdown_area').find('ul.dropdown-menu').append(html)
    $(this).parents('li').remove()
    return