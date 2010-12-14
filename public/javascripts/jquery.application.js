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
      $('.loading').fadeIn();
    },
    complete: function(req, status) {
      $('.loading').fadeOut();
    }
  });
  
  // jquery-ui fancy buttons
  $("input:submit").button();
  $('button').button({});
  
  // $('table.list tbody tr:visible').reapplyOddEven();
  $('textarea').autoResize({animate: true}).trigger('change');  
  
  $('textarea[placeholder], input[placeholder]').placeholder();
  $('.tabs').tabs();
  
  $('button.search').button({
    icons: {
      primary: 'ui-icon-search'
    },
    text: false
  })
  
  $('.program_update, .list li').live('hover', 
    function(e) {
      if( e.type == 'mouseover' || e.type == 'mouseenter' )
      {
        $(this).find('.extra_info, .hover').fadeIn(200);
      } else {
        $(this).find('.extra_info, .hover').fadeOut(500);
      }
    });
    
  $('[title]').tipsy({fade: true, gravity: 's'})
  
  $('.episode .options_bar a.refresh').Jrotate();
  
  $('.mainmenu a').each( function() {
    var $this = $(this);
    if( $this.attr('href') == document.location.pathname ) {
      $this.parent('li').addClass('current');
    }
  });
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
  
  $.fn.createNotice = function(type) {
    $this           = $(this);
    switch(type) {
      case 'error':
        $this.addClass('ui-corner-all ui-state-error');
      break;
      default:
        $this.addClass('ui-corner-all ui-state-highlight');
    }
    
    $this.attr('style', $this.attr('style') + '; padding: 0.7em; margin-bottom: 0.7em; ');
    return $this;
  }
  $.fn.errorStyle = function() {
    $this           = $(this).createNotice('error');
    return $this;
  }
  $.fn.noticeStyle = function() {
    $this           = $(this).createNotice('notice');
    return $this;
  }
})(jQuery);