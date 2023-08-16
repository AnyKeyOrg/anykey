// Handles clicks on record rows in staff dashboard
// And after four years, finally enables right/context click!

$(document).ready(function() {
  $(".record-row").click(function(e) {
    e.preventDefault();
    if ($(this).data('url'))
      window.location = $(this).data('url');
  });
  
  $(".record-row").on("contextmenu", function(e) {
    e.preventDefault();
    if ($(this).data('url'))
      window.open($(this).data('url'), '_blank');
  });
});
