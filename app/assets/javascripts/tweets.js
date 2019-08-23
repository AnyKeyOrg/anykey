/* Hide Twitter's calls to action on embedded tweets */
/* Need to wait until shadow DOM loads these widgets,
   so we check every 100ms until the tweets are ready */

$(document).ready(function() {
  var interval = setInterval(function() {
    var twitterWidgets = document.querySelectorAll("twitter-widget"); 
    
     if (twitterWidgets[0].shadowRoot.querySelector(".CallToAction") != null) {
       twitterWidgets.forEach(function(item) {
         var root = item.shadowRoot;
         root.querySelector(".CallToAction").style.display = 'none';
       });
      clearInterval(interval);
     }
   }, 500);
});