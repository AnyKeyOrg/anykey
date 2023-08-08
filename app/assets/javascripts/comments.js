// Handles posting and display of comments on commentable records

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
      dataType: 'script',
      url: this.action
    });
    
    // Clear comment box
    $('#comment_body').val('');
  }); 
}

$(document).ready(function() {
  setupCommentSubmitListener();
});
