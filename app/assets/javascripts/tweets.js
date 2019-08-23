/* Hide Twitter's calls to action on embedded tweets */

$(document).ready(function() {
  setTimeout(function(){
    var twitterWidgets = document.querySelectorAll("twitter-widget"); 

    twitterWidgets.forEach(function(item) {
      var root = item.shadowRoot;
      root.querySelector(".CallToAction").style.display = 'none';
    });
  }, 1000);
});