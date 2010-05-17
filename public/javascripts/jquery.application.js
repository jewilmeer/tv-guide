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
  $('textarea').autoResize({animate: true}).trigger('change');  
  
  $('#login').bind('click', function() {
    FB.login(handleSessionResponse);
  });

  $('#logout').bind('click', function() {
    FB.logout(handleSessionResponse);
  });

  $('#disconnect').bind('click', function() {
    FB.api({ method: 'Auth.revokeAuthorization' }, function(response) {
      clearDisplay();
    });
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
})(jQuery);

// no user, clear display
function clearDisplay() {
  $('#user-info').hide('fast');
}

// handle a session response from any of the auth related calls
function handleSessionResponse(response) {
  // if we dont have a session, just hide the user info
  if (!response.session) {
    clearDisplay();
    $('#login').show().siblings().hide();
    return;
  }
  
  // if we have a session, query for the user's profile picture and name
  FB.api(
    {
      method: 'fql.query',
      query: 'SELECT name, pic FROM profile WHERE id=' + FB.getSession().uid
    },
    function(response) {
      var user = response[0];
      $('#user-info').html('<img src="' + user.pic + '">' + user.name).show('fast');
    }
  );
  // also show the login state
  $('#login').hide().siblings().show();
  
}
