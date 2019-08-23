/* Resizes full window image backgrounds to contain content as window scales */
/* Could probably be much DRYer bu works for now */

function resizeBackgrounds() {
  var glhfInnerHeight = document.getElementById('glhf-inner').clientHeight;
  document.getElementById('glhf-section').style.height = glhfInnerHeight+160+'px';

  var twitterInnerHeight = document.getElementById('twitter-inner').clientHeight;
  document.getElementById('twitter-section').style.height = twitterInnerHeight+160+'px';
};


$(document).ready(function() {

  /* Here we wait fir the twitter-widegets to load before doing any resizing */
  
  var interval = setInterval(function() {
    var twitterWidgets = document.querySelectorAll("twitter-widget"); 
     if (twitterWidgets.length > 0) {
       resizeBackgrounds();
      clearInterval(interval);
     }
   }, 100);

  $(window).resize(function () {    
    resizeBackgrounds();   
  });
});