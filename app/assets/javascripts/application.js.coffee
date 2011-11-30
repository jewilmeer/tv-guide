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