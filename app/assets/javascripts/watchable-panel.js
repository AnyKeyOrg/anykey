// Toggles status for watchable items

function setupWatchableToggleListener() {
  $('#watchable-toggle').off('click');
  $('#watchable-toggle').click(function(e) {
  
    // Intercept click
    e.preventDefault();
    
    $.ajax({
      type: 'POST',
      processData: false,
      contentType: false,
      dataType: 'script',
      url: this.href
    });

  }); 
}

$(document).ready(function() {
  setupWatchableToggleListener();
});
