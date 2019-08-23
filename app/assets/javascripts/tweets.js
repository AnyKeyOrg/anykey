/* Hide Twitter's calls to action on embedded tweets */
/* Need to wait until shadow DOM loads this widgets,
   but this way of doing it is hacky */

$(document).ready(function() {
  setTimeout(function(){
    var twitterWidgets = document.querySelectorAll("twitter-widget"); 

    twitterWidgets.forEach(function(item) {
      var root = item.shadowRoot;
      root.querySelector(".CallToAction").style.display = 'none';
    });
  }, 2000);
});