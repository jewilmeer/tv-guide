var button_aliases = {
  'show': 'ui-icon-trash',
  'edit': 'ui-icon-trash',
  'delete': 'ui-icon-trash',
  'search': 'ui-icon-search'
};
$(function()
{
  // ajax setup
  $.ajaxSetup({
    type: 'post',
    data: { 
      authenticity_token : $('meta[name=csrf-token]').attr('content')
    },
    beforeSend: function(xhr) 
    {
      xhr.setRequestHeader("Accept", "text/javascript");
      $('.loading').removeClass('hidden')
    },
    complete: function(req, status) {
      $('.loading').addClass('hidden');
    }
  });
  
  // turn select boxes to auto completes
  // $('select.autocomplete').select_autocomplete();
  
  // jquery-ui fancy buttons
  $("input:submit").button();
  $('button').button({});
});