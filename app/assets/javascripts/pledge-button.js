/*
 * Smoothly scrolls to
 * pledge form from header
 */

function setupPledgeButton() {
  $(".pledge-button").click(function(e) {
    e.preventDefault();    
    // document.querySelector(this.getAttribute('href')).scrollIntoView({behavior: 'smooth'});

    var element = document.querySelector(this.getAttribute('href'));
       var headerOffset = 20;
       var elementPosition = element.getBoundingClientRect().top;
       var offsetPosition = elementPosition - headerOffset;

       window.scrollTo({
            top: offsetPosition,
            behavior: "smooth"
       });
  });
}

$(document).ready(function() {
  setupPledgeButton();
});