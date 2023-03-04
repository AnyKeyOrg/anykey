/* 
 * Shows and hides each FAQ answer
 * when questions are clicked.
 */

function setupFAQToggle() {
  $(".faq-item").click(function() {
    var a = document.getElementById("faq-answer-"+$(this).data('number'));
    $(a).slideToggle(200);
  });
}

$(document).ready(function() {
  setupFAQToggle();
});