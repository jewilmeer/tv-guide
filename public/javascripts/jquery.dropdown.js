$(function()
{
  $("ul.dropdown li").hover(function()
  {
    $(this).addClass("hover");
    // $('ul:first',this).css('visibility', 'visible');
  }, 
  function()
  {
    $(this).animate({opacity: 1.0}, 200, function(){ $(this).removeClass("hover")});
    // $('ul:first',this).css('visibility', 'hidden');
  });

  $("ul.dropdown li ul li:has(ul)").find("a:first").append(" <span class='more'><span>&raquo;</span></span> ");
});