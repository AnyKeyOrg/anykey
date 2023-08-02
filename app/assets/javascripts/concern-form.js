/*
 * Updates counters of remaining chars
 * in textareas on concern form in a very very very
 * not DRY way ;]
 */

$(document).ready(function() {
  var text_a       = $("#concern_background");
  var counter_a    = $("#concern-background-counter");
  var max_length_a = counter_a.data("max-length");

  text_a.keyup(function() {
    counter_a.text(max_length_a - $(this).val().length);
    if (max_length_a - $(this).val().length < 10) {
      counter_a.css("color", "var(--bright-fuchsia-color)");
    }
    else {
      counter_a.css("color", "var(--black-color)");
    }
  });
  
  var text_b       = $("#concern_description");
  var counter_b    = $("#concern-description-counter");
  var max_length_b = counter_b.data("max-length");

  text_b.keyup(function() {
    counter_b.text(max_length_b - $(this).val().length);
    if (max_length_b - $(this).val().length < 10) {
      counter_b.css("color", "var(--bright-fuchsia-color)");
    }
    else {
      counter_b.css("color", "var(--black-color)");
    }
  });
  
  var text_c       = $("#concern_recommended_response");
  var counter_c    = $("#concern-recommended-response-counter");
  var max_length_c = counter_c.data("max-length");

  text_c.keyup(function() {
    counter_c.text(max_length_c - $(this).val().length);
    if (max_length_c - $(this).val().length < 10) {
      counter_c.css("color", "var(--bright-fuchsia-color)");
    }
    else {
      counter_c.css("color", "var(--black-color)");
    }
  });
  
});