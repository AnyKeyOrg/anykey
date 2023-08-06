
function setupCommentSubmitListener() {
  $('#comment_box').submit(function(e) {
    
    // Intercept click and release button from focus state
    e.preventDefault();
    $('#comment_submit').blur();

    $.ajax({
      type: 'POST',
      data: new FormData(this),
      processData: false,
      contentType: false,
      url: this.action,
      success: function(data, textStatus, jqXHR) {
        // Show comment on page
      },
      error: function(jqXHR, textStatus, errorThrown) {
        // Panic and freak out
      }
    });
  }); 
}

$(document).ready(function() {
  setupCommentSubmitListener();
});
