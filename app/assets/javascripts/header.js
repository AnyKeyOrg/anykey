/*
 * Shows/hides user profile dropdown menu
 * attached to user avatar in staff header
 */

var dropdownMenuVisible = false;

/* Show/hide dropdown menu when clicking header avatar icon */
function setupDropdownMenuToggle() {
  $("#header-avatar-container").click(function() {
    if (!dropdownMenuVisible) {    
      dropdownMenuVisible = true;
      $("#dropdown-container").show();
    }
    else {
      dropdownMenuVisible = false;
      $("#dropdown-container").hide();
    }
  });
}

/* Hide dropdown menu on any click that is not the header avatar icon */
function setupDropdownMenuHide() { 
  $(document).click(function(e) {
    if(!$(e.target).closest("#header-avatar-container").length && !$(e.target).closest("#dropdown-menu").length) {
      if(dropdownMenuVisible) {
        dropdownMenuVisible = false;
        $("#dropdown-container").hide();
      }
    }
  });
}
  
$(document).ready(function() {
  setupDropdownMenuToggle();
  setupDropdownMenuHide();
});
