/*
 * Handles clicks on report rows in
 * staff dashboard.
 */

$(document).ready(function() {
  $(".report-row").click(function(e) {
    e.preventDefault();
    window.location = $(this).data('url');
  });
});