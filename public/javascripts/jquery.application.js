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
  
  $('table.list tbody tr:visible').reapplyOddEven();
  
});

(function($) {
  // currently this function is accepting a set of tr elements or a tbody element (set)
  $.fn.reapplyOddEven = function() {
    var i = 0;
    $(this).each(function()
    {
      elm = $(this);
      if(i%2 == 0)
      {
        elm.removeClass('even').addClass('odd');
      }
      else
      {
        elm.removeClass('odd').addClass('even');
      }
      i++;
    });
    return this;
  }
})(jQuery);
