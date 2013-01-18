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
  $('time').timeago()
  $('#program-detail-tabs a:first').tab('show')
  $('#program-season-tabs a:first').tab('show')