/*
 * When comment is submitted successfully
 * it clears out the text field
 */
$(function() {
  $('#new_comment').on('ajax:success', function(a, b,c ) {
    $(this).find('#comment_body').val('');
  });
});
