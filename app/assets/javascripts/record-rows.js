/*
 * Handles clicks on record rows in
 * staff dashboard.
 */

$(document).ready(function() {
  $(".record-row").click(function(e) {
    e.preventDefault();
    window.location = $(this).data('url');
  });
});