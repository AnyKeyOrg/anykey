/*
 * Updates counters of remaining chars
 * in textareas on report form in a very
 * not DRY way ;]
 */

$(document).ready(function() {
  var text_a       = $("#report_incident_description");
  var counter_a    = $("#incident-descripton-counter");
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
  
  var text_b       = $("#report_recommended_response");
  var counter_b    = $("#recommended-response-counter");
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
  
});