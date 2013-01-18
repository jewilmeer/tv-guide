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
  # $my_modal = $('#add_program_block').modal(
  #   backdrop: true
  #   keyboard: true
  #   modal: true
  # )

  # $('.btn.add_program').click ->
  #   $my_modal.modal('toggle')
  $('.dropdown').dropdown()
  $('.dropdown-toggle').dropdown()
  $('time').timeago()