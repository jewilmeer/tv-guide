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
    }
  });
 
  // enable data-disable-with for a elements
  $('a[data-disable-with]').each( function() {
    var link = $(this);
    link.data('enable-with', link.html());
  }).live('click.rails', function(e) {
    var link = $(this);
    link.html( link.attr('data-disable-with') );
    if ( link.attr('disabled') != 'disabled' )
      link.attr('disabled', 'disabled').callRemote();
    e.preventDefault();
  }).live('ajax:complete', function(e) {
    var link = $(this);
    link.removeAttr('disabled').html( link.data('enable-with') );
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
        $(this).find('.extra_info, .hover').show();
      } else {
        $(this).find('.extra_info, .hover').hide();
      }
    });
    
  $('[title]').tipsy({fade: true, gravity: 's'})
  
  $('.episode .icon.refresh').Jrotate();
  
  $('.mainmenu a, .user_nav a').each( function() {
    var $this = $(this);
    if( $this.attr('href') == document.location.pathname ) {
      $this.parent('li').addClass('current');
    }
  });


  // align: "center"
  // length: 2
  // padding: 4
  // segments: 6
  // space: 1
  // speed: 1
  // steps: 5
  // valign: "center"
  // width: 2
  $.fn.activity.defaults.align   = 'center'
  $.fn.activity.defaults.padding = 8
  $.fn.activity.defaults.length  = 2
  $.fn.activity.defaults.space   = 2
  $.fn.activity.defaults.width   = 2
  // $.fn.activity.defaults.width = 2
  
  $('.slides').slides({
    preload: true,
    preloadImage: '/images/spinner.gif',
    crossfade: true,
    play: 5000,
    pause: 2500,
    hoverPause: true,
    slideEasing: "fadeOut",
    effect: "fade",
    fadeSpeed: 1500,
    generatePagination: false,
    paginationClass: 'simple_pagination'
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