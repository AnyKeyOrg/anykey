// Handles posting, display, and deletion of comments on commentable records

function setupCommentBoxResize() {
  $("#comment_body").on("input", function () {
    this.style.height = 0;
    this.style.height = (this.scrollHeight) + "px";
  });
}

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

function setupCommentDeleteActions() {
  $('.comment-delete-form').off('submit');
  $('.comment-delete-form').submit(function(e) {
    
    // Intercept click
    e.preventDefault();
    
    $.ajax({
      type: 'DELETE',
      data: new FormData(this),
      processData: false,
      contentType: false,
      dataType: 'script',
      url: this.action
    });
    
  });
}

$(document).ready(function() {
  setupCommentBoxResize();
  setupCommentSubmitListener();
  setupCommentDeleteActions();
});
