###
= require jquery
= require jquery_ujs
= require './lib/bootstrap/bootstrap'
= require './lib/timeago.jquery'
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
    if match = uri.match(/\/tvdb_images\/(\d+)\//)
      image_id = match[1]
      uri = document.location.origin + '/images/' + image_id + '.jpg'
      console?.log('image broken, reloading on', uri)
    $.post uri, {_method: 'PUT', save: true}
      
