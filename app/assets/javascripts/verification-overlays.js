/*
 * Shows and hides overlays for opening
 * original assets on verification review.
 */

function setupVerificationOverlays() { 
  $("#verification-photo-id").mouseover(function(e) {
    $("#photo-id-overlay").show();
  });
  
  $("#verification-photo-id").mouseout(function(e) {
    $("#photo-id-overlay").hide();
  });
  
  $("#verification-photo-id").click(function(e) {
    e.preventDefault();
    window.open($(this).data('url'), "_blank");
  });
  
  $("#verification-doctors-note").mouseover(function(e) {
    $("#doctors-note-overlay").show();
  });
  
  $("#verification-doctors-note").mouseout(function(e) {
    $("#doctors-note-overlay").hide();
  });
  
  $("#verification-doctors-note").click(function(e) {
    e.preventDefault();
    window.open($(this).data('url'), "_blank");
  });
}

$(document).ready(function() {
  setupVerificationOverlays()
});