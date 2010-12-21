(function($) {
  $.fn.Jrotate = function(options) {
    var defaults = {
      degrees: 10, //degrees that should be rotated
      speed: 30 //degrees that should be rotated
    }
    options = $.extend({}, defaults, options);
    
    return this.each(function() {
      // init the index      
      var $this = $(this);
      $this.data('options', options);
      $this.data('current_degrees', 0);
      $this.hover( function() {
        $this.data('cancel.jrotate', false);
        $this.doTimeout((options['speed']), function() {
          // cancel the loop
          if( $this.data('cancel.jrotate') == true ) return false;
          
          // set the new current_degrees and apply them
          var current_degrees = $this.data('current_degrees') + options['degrees'];
          $this.data('current_degrees', current_degrees );
          $this.css('-webkit-transform', 'rotate('+ current_degrees +'deg)');
          $this.css('-moz-transform', 'rotate('+ current_degrees +'deg)');
          return true;
        });
      }, function() {
        $this.data('cancel.jrotate', true);
      });
    });
  };
  $.fn.Jrotate.rotate_start = function() {
    
  },
  $.fn.Jrotate.rotate_step = function() {
    
  },
  $.fn.Jrotate.rotate_stop = function() {
    
  }
  
})(jQuery);