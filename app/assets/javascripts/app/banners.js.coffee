$ ->
  $('#banners input[type=radio]').live 'change', ->
    $.ajax( 
      $(@).parents('form').attr('action'),
      type: 'POST'
      data:
        'program[series_image_id]': $(@).val()
        _method: 'PUT'
    )
    $(@).parents('.row').addClass('placeholder').siblings().removeClass('placeholder')
