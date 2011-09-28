###
= require jquery
= require jquery_ujs
= require twitter/bootstrap
= require_self
= require_tree .
###

$ ->
  console.log 'App initialized'
  $my_modal = $('#add_program_block').modal(
    backdrop: true
    keyboard: true
    modal: true
  )
  $('.btn.add_program').click ->
    $my_modal.modal('toggle')