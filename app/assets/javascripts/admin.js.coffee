###
= require jquery
= require jquery_ujs
= require './lib/prettify'
= require bootstrap
= require './lib/timeago.jquery'
= require './lib/jquery.isotope.min'
= require_tree ./app
= require_self
###

$ ->
  $('time').timeago()

  $('#images .media-grid img').hover ->
    $(@).toggleClass('fullsize')
  ->
    $(@).toggleClass('fullsize')

  iso = $('#images .images').isotope
    itemSelector: '.image'
    filter: $('ul.isotope-control.filter .saved').data('filter_css')
    getSortData:
      created_at: (elm) ->
        elm.data('created_at')
      image_type: (elm) ->
        elm.data('image_type')

  $('ul.isotope-control.sort, ul.isotope-control.filter').click (e) ->
    target = $(e.target)
    if target.is('a:not(.selected)')
      # do the magic
      if $(@).hasClass('sort')
        console?.log 'Applying sort on:', target.attr('class')
        iso.isotope
          sortBy: target.attr('class')
      if $(@).hasClass('filter')
        console?.log 'Applying filter on: "', target.data('filter_css'), '"', target
        iso.isotope
          filter: target.data('filter_css')
      # add correct selected state
      $(@).find('a').removeClass('selected')
      target.addClass('selected')

  prettyPrint()

  $('#tvdb_update').click ->
    $this = $(@)
    $.getJSON $this.attr('href'), (data) ->
      list = $('<dl></dl>')
      for key, value of data
        list.append("<dt>#{key}</dt>")
        list.append("<dd>#{value}</dd>")
      $this.after list

  isScrolledIntoView = (elem) ->
    docViewTop = $(window).scrollTop()
    docViewBottom = docViewTop + $(window).height()
    elemTop = $(elem).offset().top
    elemBottom = elemTop + $(elem).height()
    (elemTop >= docViewTop) && (elemTop <= docViewBottom)

  if $('.pagination').length
    $(window).scroll ->
      url = $('.pagination .next a').attr('href')
      if url && isScrolledIntoView('.pagination')
        $('.pagination').text("Fetching more products...")
        $.getScript(url)
    $(window).scroll()