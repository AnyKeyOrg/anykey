/* Resizes full window image backgrounds to contain content as window scales */
/* Could probably be much DRYer bu works for now */

/* TODO: make sure this doesn't throw errors on pages without these elements */

function resizeBackgrounds() {
  var glhfInnerHeight = document.getElementById('glhf-inner').clientHeight;
  document.getElementById('glhf-section').style.height = glhfInnerHeight+160+'px';

  var twitterInnerHeight = document.getElementById('twitter-inner').clientHeight;
  document.getElementById('twitter-section').style.height = twitterInnerHeight+160+'px';
};


$(window).load(function() {

  resizeBackgrounds();
 
  $(window).resize(function () {    
    resizeBackgrounds();   
  });
});