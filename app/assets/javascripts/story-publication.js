/*
 * Handles hiding/showing the published on
 * date and time fields on stories.
 */

$(document).ready(function() {
  
  /* Onload set the form up properl */
  var e = document.getElementById("story_published");  
  if (e.options[e.selectedIndex].value == "false") {
     $("#story_published_on").hide()
  }
  
  /* Onchange show/hide the published on field */
  $("#story_published").on("change",function(){
    if ($(this).val() == "true") {
      $("#story_published_on").show()
    }
    else {
     $("#story_published_on").hide()
    }
  });
  
});
