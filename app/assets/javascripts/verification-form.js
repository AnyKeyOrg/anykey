/*
 * Updates counters of remaining chars
 * in textareas on verification form in a very very
 * not DRY way ;]
 */

$(document).ready(function() {
  var text_a       = $("#verification_additional_notes");
  var counter_a    = $("#additional-notes-counter");
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
});