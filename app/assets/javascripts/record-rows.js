/*
 * Handles clicks on record rows in
 * staff dashboard.
 */

$(document).ready(function() {
  $(".record-row").click(function(e) {
    e.preventDefault();
    if ($(this).data('url'))
      window.location = $(this).data('url');
  });
});
