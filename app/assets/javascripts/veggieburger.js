var veggieBurgerMenuVisible = false;

/* Show/hide dropdown menu when clicking veggieburger icon */
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