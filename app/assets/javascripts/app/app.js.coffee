$ ->
  $('#program-detail-tabs a:first').tab('show')

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
        $('.pagination').text("Searching for moar!")
        $.getScript(url)
    $(window).scroll()
  $('#past-episodes').on 'click', 'a i', ->
    $(@).addClass('icon-spin').parent('a').attr('disabled', 'disabled')

  $('.program_search, #program_preference_q').typeahead
    name: 'programs',
    source: (query, typeahead) ->
      $.getJSON '/api/programs.json', query: query, (data) ->
        typeahead(data)
