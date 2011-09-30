$ ->
  console.log('fantastisch')

  $('dl#next-airing dd').click =>
    console.log 'gaat oe dan', @
    document.location.href= $(@).find('a').attr('href')
  