//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require turbolinks
//= require bootstrap.min.js
//= require gentelella
//= require gentelella-custom

$(function() {
    $('#flash').delay(500).fadeIn('normal', function() {
        $(this).delay(2500).fadeOut();
    });
});

function CheckLocation(){
	  $(document).mousedown(function(e){
	    // context menu 가 아닌 다른 영역을 클릭한경우 판단
	    if ($(e.target).parents(".contextmenu").length !== 0)
	      return;
	    $(".contextmenu").hide();
	    $(document).unbind('mousedown');
	  });
}
function ShowContextMenu(className){
	$("."+className).css({
    left:event.pageX+"px",
    top:event.pageY+"px"
  }).show();
}
