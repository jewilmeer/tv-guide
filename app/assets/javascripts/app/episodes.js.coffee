$ ->
  $('dl#next-airing dd').click =>
    document.location.href= $(@).find('a').attr('href')
  