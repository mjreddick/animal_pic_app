(function() {
  var ready = function(){

    // swipe left/right to move between pictures
    // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
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
    // <<<<<<<<<<<<<<<<<<<<<<<<<<<< swipe left/right 

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

    $('#friend-btn').click(sendVote);
    $('#fiend-btn').click(sendVote);



    function sendVote() {
      console.log("inside sendVote")
      var type = $(this).data('type');
      
      var pathArray = window.location.pathname.split('/');
      // remove any empty strings
      pathArray = $.grep(pathArray,function(n){ return(n) });
      var picId = pathArray[pathArray.length - 1];
      
      $.ajax({
        method: "PATCH",
        url: "/api/pictures/" + picId + "/vote",
        data: { vote_type: type }
      })

      var otherButton;

      if(type == "friend") {
        otherButton = $('#fiend-btn');
      }
      else {
        otherButton = $('#friend-btn');
      }
      otherButton.removeClass("selected").addClass("unselected");

      $(this).removeClass("unselected").addClass("selected");

    }

    console.log("loaded!")

  };

  $(document).ready(ready);
  $(document).on('page:load', ready);


})();





