$(function(){

  document.addEventListener('touchstart', handleTouchStart, false);        
  document.addEventListener('touchend', handleTouchEnd, false);

  var xDown = null;                                                        
  var yDown = null;  

  function handleTouchStart(evt) {                                         
    xDown = evt.touches[0].clientX;                                      
    yDown = evt.touches[0].clientY;                                      
  }

  function handleTouchEnd(evt) {
    if ( !xDown || !yDown ) {
      return;
    }

    var xUp = evt.changedTouches[0].clientX;                                    
    var yUp = evt.changedTouches[0].clientY;

    var xDiff = xDown - xUp;
    var yDiff = yDown - yUp;

    // horizontal swipe should be more significant than verticle
    if ( Math.abs( xDiff ) > Math.abs( yDiff ) ) {
      if ( xDiff > 100 ) {
        /* left swipe */ 
        clickButton('#next-pic-btn');
      } 
      else if ( xDiff < -100 ){
        /* right swipe */
        clickButton('#prev-pic-btn');
      }                       
    } 
    /* reset values */
    xDown = null;
    yDown = null;                                             
  };                                               

  // detect keydown events in order to allow a user to use 
  // left arrow (or a) to go to the last picture and
  // right arrow (or d) to go to the next picture
  window.onkeydown = function(keyDown) {
    switch (keyDown.keyCode) {
      // right arrow
      case 39:
      // d
      case 68:
      clickButton('#next-pic-btn');
      break;
      // left arrow
      case 37:
      // a
      case 65:
      clickButton('#prev-pic-btn');
      break;
      default:
      break;
    }
  };

  function clickButton(name) {
    var button = $(name)[0];
    if(button) {
      button.click();
    }
  }

});





