$(function(){

  // detect keydown events in order to allow a user to use 
  // left arrow (or a) to go to the last picture and
  // right arrow (or d) to go to the next picture
  window.onkeydown = function(keyDown) {
    switch (keyDown.keyCode) {
      // right arrow
      case 39:
      // d
      case 68:
      clickButton('#next-pic-btn')
      break;
      // left arrow
      case 37:
      // a
      case 65:
      clickButton('#prev-pic-btn')
      break;
      default:
      break;
    }
  }
});

function clickButton(name) {
  var button = $(name)[0];
  if(button) {
    button.click();
  }
}

