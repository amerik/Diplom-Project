//= require lib/slick.min

$(document).ready ->
  $('.partners_slider').slick()

  #####reviews_slider
  $('.mentors_slider .control').click (event)->
    event.preventDefault()
    parent = $(this).parents('.slider-item-selected')
    size = parent.find('.slide_contents').size() - 1
    active_content = parent.find('.slide_contents.active')
    index =  active_content.index()
    parent.find('.slide_contents').eq(index).removeClass('active')
    $(this).parents('.mentors_slider').find('.items_list').find('a').removeClass('active')
    if $(this).hasClass('prev')
      console.log('prev')
      if index > 0
        parent.find('.slide_contents').eq(index-1).addClass('active')
        $(this).parents('.mentors_slider').find('.items_list').find('a').eq(index-1).addClass('active')
      else
        parent.find('.slide_contents').eq(size).addClass('active')
        $(this).parents('.mentors_slider').find('.items_list').find('a').eq(size).addClass('active')
    else
      console.log('next')
      unless size <= index
        parent.find('.slide_contents').eq(index+1).addClass('active')
        $(this).parents('.mentors_slider').find('.items_list').find('a').eq(index+1).addClass('active')
      else
        parent.find('.slide_contents').eq(0).addClass('active')
        $(this).parents('.mentors_slider').find('.items_list').find('a').eq(0).addClass('active')
  $('.mentors_slider .items_list a').click (event)->
    event.preventDefault()
    index = $(this).index()
    unless $(this).hasClass('active')
      $(this).parent().find('a').removeClass('active')
      $(this).addClass('active')
      $(this).parents('.mentors_slider').find('.slide_contents').removeClass('active')
      $(this).parents('.mentors_slider').find('.slide_contents').eq(index).addClass('active')
  ##############

  $('.choosing-mentor ul li a').click (event)->
    event.preventDefault()
    unless $(this).hasClass('active')
      el = $(this)
      el.parents('ul').find('a').removeClass('active')
      $('.choosing-mentor .contents').hide()
      el.addClass('active')
      name = el.data('name')
      $('.choosing-mentor .contents.'+name).show()
      

  $('.mentors__list .more-career-view').click (event)->
    event.preventDefault()
    $(this).parents('.mentor_item').find('.choice ul').addClass('show-all')
    $(this).hide()

    