// Toggles status for watchable items

function setupWatchableToggleListener() {
  $('#watchable-toggle').click(function(e) {
    
    // Intercept click
    e.preventDefault();
    
    var url = '';
    
    // Determine which endpoint to use
    if ($(this).hasClass('watched')) {
      url = $(this).data('watched-url');
    } else {
      url = $(this).data('unwatched-url');
    }
    
    $.ajax({
      type: 'POST',
      processData: false,
      contentType: false,
      url: url,
      success: function(data, textStatus, jqXHR) {
        // Change the button
        $('#watchable-toggle').attr("class", data["watched_status"]);
      },
      error: function(jqXHR, textStatus, errorThrown) {
        // Do nothing
      }
    });
  }); 
}

$(document).ready(function() {
  setupWatchableToggleListener();
});
