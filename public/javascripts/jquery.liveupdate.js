(function($) {
  jQuery.fn.live_update = function(url, options) {
    var settings = jQuery.extend({
       last_request: last_request,
       id: 'live_update',
       interval: 30000,
       success: function(data) {
         if(data.success && data.entries && data.entries.length > 1 )
         {
           $(self).prepend($(data.entries)).reapplyOddEven();
          last_request = data.last_request;
         }
       }
    }, options);
    var self = this
    $.doTimeout(settings.id, settings.interval, function() {
      $.getJSON(
        url,
        { last_request: last_request },
        settings.success
      );
      return true;
    });
    return this;
  }
  // call
  // $.doTimeout( [given value of settings.id] );
  // to stop the live update
})(jQuery);
