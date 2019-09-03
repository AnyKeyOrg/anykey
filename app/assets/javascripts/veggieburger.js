/* 
 * Shows and hides dropdown menu
 * when veggieburger icon in header
 * is clicked.
 */

var veggieBurgerMenuVisible = false;

function setupVeggieBurgerMenuToggle() {
  $("#veggieburger").click(function() {
    if (!veggieBurgerMenuVisible) {
      veggieBurgerMenuVisible = true;
      $("#veggieburger-menu").slideDown(300);
    }
    else {
      veggieBurgerMenuVisible = false;
      $("#veggieburger-menu").slideUp(300);
    }
  });
}

$(document).ready(function() {
  setupVeggieBurgerMenuToggle();
});