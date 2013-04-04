$ ->
  $('#program-detail-tabs a:first').tab('show')
  $('[data-toggle="tooltip"]').tooltip()
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
  $('#past-episodes').on 'click', 'a i', ->
    $(@).addClass('icon-spin').parent('a').attr('disabled', 'disabled')