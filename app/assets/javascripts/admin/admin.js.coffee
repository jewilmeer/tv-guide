$ ->
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
      url = $('.pagination .next_page').attr('href')
      if url && isScrolledIntoView('.pagination')
        $('.pagination').text("Fetching more products...")
        $.getScript(url)
    $(window).scroll()