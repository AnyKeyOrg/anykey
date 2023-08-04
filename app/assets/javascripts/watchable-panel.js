
function setupWatchablePanelListener() {
  $('#watchable-panel').click(function(e) {
    
    // Intercept click and release button from focus state
    e.preventDefault();

    $.ajax({
      type: 'POST',
      processData: false,
      contentType: false,
      url: this.href,
      success: function(data, textStatus, jqXHR) {
        // Change the button
        $('#watchable-panel').attr("href", "https://newlink");
        $('#watchable-panel').attr("class", "newclass");
        
        
        
      },
      error: function(jqXHR, textStatus, errorThrown) {
        // Don't
      }
    });
  }); 
}

$(document).ready(function() {
  setupWatchablePanelListener();
});
