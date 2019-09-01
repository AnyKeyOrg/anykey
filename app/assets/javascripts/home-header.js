var backgrounds = [
  '/images/home-header-a.jpg',
  '/images/home-header-b.jpg',
  '/images/home-header-c.jpg',
  '/images/home-header-d.jpg'
];

var bgIndex = 0;

function swapBackgrounds() {
  if (++bgIndex >= backgrounds.length) {
  	bgIndex = 0;
  }
  
  console.log(bgIndex);
  $('#home-header').css("background-image", "url('" + backgrounds[bgIndex] + "')");
}

setInterval(swapBackgrounds, 5000);