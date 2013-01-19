###
= require jquery
= require jquery_ujs
= require bootstrap
= require './lib/timeago.jquery'
= require './lib/jquery.isotope.min'
= require './lib/prettify'
= require_tree ./app
= require_self
###

$ ->
  $('time').timeago()
  $('#program-detail-tabs a:first').tab('show')
  $('#program-season-tabs a:first').tab('show')

  isScrolledIntoView = (elem) ->
    docViewTop = $(window).scrollTop()
    docViewBottom = docViewTop + $(window).height()
    elemTop = $(elem).offset().top
    elemBottom = elemTop + $(elem).height()
    (elemTop >= docViewTop) && (elemTop <= docViewBottom)

  if $('.pagination').length
    $(window).scroll ->
      url = $('.pagination .next_page').attr('href')
      if url && isScrolledIntoView('.pagination')
        $('.pagination').text("Fetching more products...")
        $.getScript(url)
    $(window).scroll()