###
= require jquery
= require jquery_ujs
= require './lib/bootstrap/bootstrap'
= require './lib/timeago.jquery'
= require './lib/jquery.isotope.min'
= require_tree ./app
= require_self
###

$ ->
  $my_modal = $('#add_program_block').modal(
    backdrop: true
    keyboard: true
    modal: true
  )
  
  $('.btn.add_program').click ->
    $my_modal.modal('toggle')
  $('.dropdown').dropdown()
  $('time').timeago()

  $('img').error ->
    uri = $(@).attr('src')

    # handle s3 images differently
    regexp = new RegExp( /\/tvdb_images\/(\d+)\// )
    if match = uri.match(regexp)
      console?.log('s3 image broken on', uri)
      image_id = match[1]
      uri = document.location.origin + '/images/' + image_id + '.jpg'
      console?.log 'replacing with local one', uri
      $(@).attr('src', uri)
    else
      console?.log "none s3 image. Trying to update the image", uri
      $.post uri, {_method: 'PUT', save: true}, =>
        console?.log "image updated, has it worked?", @
        $(@).attr('src', $(@).attr('src'))
        console?.log 'reloaded', @

      
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
  
