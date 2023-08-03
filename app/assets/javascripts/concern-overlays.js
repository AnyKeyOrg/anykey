/*
 * Shows and hides overlays for opening
 * original assets on concern review.
 */

function setupConcernOverlays() {
  var concern_screenshots = $('#concern-screenshots');
  if (concern_screenshots) {
    for (var i=0; i < concern_screenshots.data('count'); i++){
      console.log("#concern-screenshot-"+i);
      $("#concern-screenshot-"+i).mouseover(function(e) {
        console.log("mousedover");
        console.log("#concern-screenshot-overlay-"+i);
        $("#concern-screenshot-overlay-"+i).show();
      });

      $("#concern-screenshot-"+i).mouseout(function(e) {
        console.log("mousedout");
        console.log("#concern-screenshot-overlay-"+i);
        $("#concern-screenshot-overlay-"+i).hide();
      });

      $("#concern-screenshot-"+i).click(function(e) {
        e.preventDefault();
        window.open($(this).data('url'), "_blank");
      });
    }
  }
}

$(document).ready(function() {
  setupConcernOverlays()
});