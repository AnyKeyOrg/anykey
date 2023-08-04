/*
 * Shows and hides overlays for opening
 * original assets on concern review
 * in a super DRY way! Recycle this!
 */

function setupConcernOverlays() {
  $(".concern-screenshot").on("mouseover mouseout", function() {
    $(this).find(".concern-screenshot-overlay").toggle();
  });
  
  $(".concern-screenshot").click(function(e) {
    e.preventDefault();
    window.open($(this).data('url'), "_blank");
  });
}

$(document).ready(function() {
  setupConcernOverlays()
});