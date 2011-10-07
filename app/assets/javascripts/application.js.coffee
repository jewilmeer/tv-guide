###
= require jquery
= require jquery_ujs
= require twitter/bootstrap
= require_tree ./app
= require_self
###

$ ->
  console.log 'app dom onload started'
  $my_modal = $('#add_program_block').modal(
    backdrop: true
    keyboard: true
    modal: true
  )
  $('.btn.add_program').click ->
    $my_modal.modal('toggle')
  $('.dropdown').dropdown()
