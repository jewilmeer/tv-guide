$(function()
{
  // autocomplete select search, based on options inside the select
  // turn select boxes to auto completes
  $('form.search').bind('submit', redirect_to_element);
  $('form.search input[type="submit"]').bind('click', redirect_to_element);
  
  // auto apply odd even based on visible structure
  $('tbody tr:visible').reapplyOddEven();
  
  // autocomplete defaults
  window.ac_default = {
    minChars: 3,
    max: 30,
    parse: function(data) {
      var parsed = [];
      data = JSON.parse(data);

      for (var i = 0; i < data.length; i++) {
          parsed[parsed.length] = {
              data: data[i],
              value: data[i].value,
              result: data[i].input_value
          };
      }
      return parsed;
    },
    formatItem: function(data, i, total) {
      return data.display_value;
    }
  }
  
  // Ajax autocomplete
  $('input.autocomplete').each(function(elm) {
    var $this = $(this);
    $this.closest('form')
      .submit(function(event) { 
        event.preventDefault(); 
      })
      .find("p").attr('style', 'display:none');
    // create the autocomplete
    $this.autocomplete($this.closest('form').attr('action'), window.ac_default).result(function(e, data) {
      // notify of redirect
      $(e.target).attr('disabled', 'disabled').parent().after($('<p><img src="/images/spinner.gif" /> Redirecting, please wait...</p>'));
      // remove search and add the username
      var arrUrl = $(e.target).closest('form').attr('action').split('/');
      arrUrl.pop();
      arrUrl.push(data.value);
      // redirect!
      document.location.href = arrUrl.join('/');
    });
  })
  
  // get all internal links
  // only those that are not ajax (nog with #)
  $('a[href^=/][href!=#]').each(function(elm) {
    var $this = $(this);
    // the icons have special loading stuff
    $this.has('img.icon').one('click', function() {
      $(this).html($('<img src="/images/spinner.gif" />'));
    });
    // no image inside link tag
    $this.filter(function() { return $(this).children('img').length == 0 }).one('click', function() {
      $(this).text('Loading...');
    });
  });
});

// JW: autocomplete select stuff events dingus
function redirect_to_element(e)
{
  e.preventDefault();
  document.location.href = $(e.target).closest('form').attr('action') + '/' + $('form.search select.autocomplete').val();
}

(function($) {
  // currently this function is accepting a set of tr elements or a tbody element (set)
  $.fn.reapplyOddEven = function() {
    var i = 0;
    var trElements = this.is('tr') ? this : this.find('tr:visible');
    trElements.each(function()
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