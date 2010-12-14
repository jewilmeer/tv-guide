(function($) {
  $.fn.Jrotate = function(options) {
    var defaults = {
      speed: 30
    }
    options = $.extend({}, defaults, options);
    
    return this.each(function() {
      // init the index      
      var $this = $(this);
      $this.data('Jindex', 0);
      $this.data('options', options);
      
      $this.click( function() {
        $this.data('cancel.jrotate', false);
        $this.doTimeout((speed/3), function() {
          if( $this.data('cancel.jrotate') == true ) return;
          var index = $(this).data('Jindex');
          if ( index >= $(this).data('options').degrees.length ) {
            index = 0;
          }
        
          $this.css('-webkit-transform', 'rotate('+ $this.data('options').degrees[index]  +'deg)');
          $(this).data('Jindex', index + 1);
          return true;
        });
      });
      
    });
  };
})(jQuery);