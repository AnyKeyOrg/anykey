/*
 * Shows and hides overlay for screenshot
 * original image display on report review.
 */

function setupScreenshotOverlay() { 
  $("#report-screenshot").mouseover(function(e) {
    $("#screenshot-overlay").show();
  });
  
  $("#report-screenshot").mouseout(function(e) {
    $("#screenshot-overlay").hide();
  });
  
  $("#report-screenshot").click(function(e) {
    e.preventDefault();
    window.open($(this).data('url'), "_blank");
  });
}

$(document).ready(function() {
  setupScreenshotOverlay()
});