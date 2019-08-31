/* 
 * Hide Twitter's calls to action on embedded tweets
 * Need to wait until shadow DOM loads these widgets,
 * so we check every 100ms until the tweets are ready
 */

$(window).load(function() {
  if (document.getElementById("twitter-widget-0") != null) {
    var twitterWidgets = document.querySelectorAll("twitter-widget");
    twitterWidgets.forEach(function(item) {
      var root = item.shadowRoot;
      root.querySelector(".CallToAction").style.display = 'none';
    });
  }
});