//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require turbolinks
//= require bootstrap.min.js

//= require gentelella/src/js/custom.js
//= require gentelella/vendors/Chart.js/dist/Chart.min.js
//= require gentelella/vendors/Flot/jquery.flot.js
//= require gentelella/vendors/Flot/jquery.flot.pie.js
//= require gentelella/vendors/Flot/jquery.flot.time.js
//= require gentelella/vendors/Flot/jquery.flot.stack.js
//= require gentelella/vendors/Flot/jquery.flot.resize.js
//= require gentelella/vendors/datatables.net-buttons-bs/js/buttons.bootstrap.min.js
//= require gentelella/vendors/datatables.net-responsive-bs/js/responsive.bootstrap.js
//= require gentelella/vendors/dropzone/dist/min/dropzone.min.js
//= require gentelella/vendors/moment/moment.js
//= require gentelella/vendors/nprogress/nprogress.js
//= require gentelella/vendors/validator/validator.js

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
