// Handles clicks on record rows in staff dashboard
// And after four years, finally enables Cmd/Ctrl click!

$(document).ready(function() {
  $(".record-row").click(function(e) {
    e.preventDefault();
    if ($(this).data('url')) {
      if (e.metaKey || e.ctrlKey)
        window.open($(this).data('url'), '_blank');
      else
        window.location = $(this).data('url');
    }
  });
});
