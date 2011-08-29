$(function() {
  $("body").bind("click", function (e) {
    $('a.menu').parent("li").removeClass("open");
  });

  $("a.menu").click(function (e) {
    var $li = $(this).parent("li").toggleClass('open');
    return false;
  });

  $('.tabs li').click( function() {
    $(this).addClass('active');
    $(this).siblings().removeClass('active');
  
    var tab = $(this).data('tab');
    var href = $(this).find('a').attr('href');
    var hash = href.substring(href.indexOf('#')+1);

    // toggle the content
    console.log( '#tab-'+hash, $('#tab-'+hash) );
    $('#tab-'+hash).siblings('.tab-content').hide();
    $('#tab-'+hash).fadeIn('fast');

    return false;
  });

  $('table.sortable').tablesorter();

  $('.slides').slides({
    preload: true,
    preloadImage: '/images/spinner.gif',
    crossfade: true,
    play: 8000,
    pause: 5000,
    hoverPause: true,
    slideEasing: "fadeOut",
    effect: "fade",
    fadeSpeed: 1500,
    generatePagination: false,
    paginationClass: 'simple_pagination',
    animationStart: function(){
      $('.caption').animate({
        bottom:-120
      },300);
    },
    animationComplete: function(current){
      $('.caption').animate({
        bottom:0
      },200);
     // if (window.console && console.log) {
     //   // example return of current slide number
     //   console.log(current);
     // };
    }
  });

  
});
