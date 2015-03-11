(function() {
  var ready = function(){

    // swipe left/right to move between pictures
    // >>>>>>>>>>>>>>>>SWIPE>>>>>>>>>>>>>>>>>>>>>>>>
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
    // <<<<<<<<<<<<<<SWIPE<<<<<<<<<<<<<<<<<<<<

    // detect keydown events in order to allow a user to use 
    // left arrow (or a) to go to the last picture and
    // right arrow (or d) to go to the next picture
    // as well as press enter to submit a comment
    // >>>>>>>>>>>>>>KEYDOWN>>>>>>>>>>>>>>>>>>>>>>>
    window.onkeydown = function(keyDown) {
      switch (keyDown.keyCode) {
        // right arrow
        case 39:
        // d
        case 68:
        if(! $('#comment-input').is(':focus')) {
          clickButton('#next-pic-btn');
        }
        break;
        // left arrow
        case 37:
        // a
        case 65:
        if(! $('#comment-input').is(':focus')) {
          clickButton('#prev-pic-btn');
        }
        break;
        // enter
        case 13:
        if($('#comment-input').is(':focus')) {
          submitComment();
          return false
        }
        break;
        default:
        break;
      }
    };

    // <<<<<<<<<<<<<<KEYDOWN<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    //>>>>>>>>>>>>>>>VOTING>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    $('#friend-btn').click({vote_type: "friend"}, voteBtnClicked);
    $('#fiend-btn').click({vote_type: "fiend"}, voteBtnClicked);

    function voteBtnClicked(event){

      var vote_type = event.data.vote_type;
      // refs to dom elements
      var friendBtn = $('#friend-btn');
      var fiendBtn = $('#fiend-btn');
      var bar = $('.pic-friend-bar');

      // get the vote values before click
      var votedFriend = friendBtn.data('voted');
      var votedFiend = fiendBtn.data('voted');

      var picId = getPictureId();

      if(vote_type == "friend") {
        if(votedFriend) {
          // removing a friend vote
          setVoted(false, false);

          // decrement number of friend votes
          bar.data('friends', bar.data('friends') - 1);
          
          removeVote();
        }
        else if(votedFiend) {
          // change vote from fiend to friend
          setVoted(true, false);
          castVote("friend", 0, 1);
        }
        else {
          // adding a friend vote
          setVoted(true, false);
          castVote("friend", 1, 1);
        }
      }
      else {
        if(votedFiend) {
          // removing a fiend vote
          setVoted(false, false);
          removeVote();
        }
        else if(votedFriend) {
          // change vote from friend to fiend
          setVoted(false, true);
          castVote("fiend", 0, -1);
        }
        else {
          // adding a fiend vote
          setVoted(false, true);
          castVote("fiend", 1, 0);
        }
      }

      // Take care of updating the display

      // update the vote buttons
      friendBtn.removeClass('selected unselected');
      fiendBtn.removeClass('selected unselected');

      if(friendBtn.data('voted')) {
        friendBtn.addClass('selected');
        fiendBtn.addClass('unselected');
      }
      else if(fiendBtn.data('voted')) {
        fiendBtn.addClass('selected');
        friendBtn.addClass('unselected');
      }
      else {
        friendBtn.addClass('unselected');
        fiendBtn.addClass('unselected');
      }
      
      // update the friend percentage meter
      var friendPercent;
      if(bar.data('votes') == 0) {
        friendPercent = 50;
      }
      else {
        friendPercent =  Math.floor((bar.data('friends') / bar.data('votes')) * 100);
      }

      $('.friend-progress-bar')[0].style.width = friendPercent + '%';

      // Update the total number of votes

      $('#num-votes').text(bar.data('votes')+ " " + (bar.data('votes') == 1 ? "Vote" : "Votes"));
      // Helper functions 

      function setVoted(friendVote, fiendVote) {
        friendBtn.data('voted', friendVote);
        fiendBtn.data('voted', fiendVote);
      }

      function removeVote() {
        // decrement the total votes
        bar.data('votes', bar.data('votes') - 1);
        
        $.ajax({
          method: 'PATCH',
          url: '/api/pictures/' + picId + '/remove_vote'
        });
      }

      // cast a vote for vote_type ("friend" or "fiend")
      // total_inc will be added to total number of votes
      // friends_inc will be added to number of friend votes
      function castVote(vote_type, total_inc, friends_inc) {
        // make api call
        // set friend votes
        bar.data('friends', bar.data('friends') + friends_inc);
        // set total votes
        bar.data('votes', bar.data('votes') + total_inc);
        
        $.ajax({
          method: 'PATCH',
          url: '/api/pictures/' + picId + '/vote',
          data: { vote_type: vote_type }
        });
      } // castVote

    } // voteBtnClicked
    // <<<<<<<<<<<<<<VOTING<<<<<<<<<<<<<<<<<<<<<<<<<<<

    // >>>>>>>>>>>>>FAVORITING>>>>>>>>>>>>>>>>>
    $('#fav-btn').click(favBtnClicked);

    function favBtnClicked() {
      var favBtn = $('#fav-btn');
      var picId = getPictureId();

      if(favBtn.data('favorited')) {
        $.ajax({
          method: 'PATCH',
          url: '/api/users/remove_favorite/',
          data: { picture_id: picId }
        });
      }
      else {
        $.ajax({
          method: 'PATCH',
          url: '/api/users/add_favorite/',
          data: { picture_id: picId }
        });
      }

      favBtn.data('favorited', !favBtn.data('favorited'));

      favBtn.removeClass('selected unselected');

      if(favBtn.data('favorited')) {
        favBtn.addClass('selected');
      }
      else {
        favBtn.addClass('unselected');
      }
    }
    // <<<<<<<<<<<<<FAVORITING<<<<<<<<<<<<<<<<<

    // >>>>>>>>>>>>>SUBMIT COMMENTS>>>>>>>>>>>>>>>>>>>

    $('#comment-submit').click(submitComment);

    function submitComment() {
      var commentText = $('#comment-input').val();

      // make sure the comment isn't empty
      if(commentText) {
        $.ajax({
          method: 'POST',
          url: '/api/comments',
          data: { text: commentText, picture_id: getPictureId() }
        });

        // add the comment to the display
        $('#comments-container').append(createCommentHtml(commentText));
      }

      // reset the input box
      $('#comment-input').val("");

    }

    function createCommentHtml(commentText) {
      // get link to current user
      var profileLinkTag = $('#profile-link');
      var profilePath = "#";
      var username = "user"
      if(profileLinkTag.length) {
        username = profileLinkTag.data('username');
        profilePath = profileLinkTag[0].pathname;
      }
      var comment = '<div class="single-comment-box">';
      
      comment += '<a href="' + profilePath + '">' + username + '</a>';
      comment += '<span> : Just now</span>';
      comment += '<p>' + commentText + '</p>';
      comment += '</div>';

      return comment;
    }

    // <<<<<<<<<<<<<SUBMIT COMMENTS<<<<<<<<<<<<<<<<<<<


    // >>>>>>>>>>>>>HELPER FUNCS>>>>>>>>>>>>>>
    function getPictureId() {
      var pathArray = window.location.pathname.split('/');
      // remove any empty strings
      pathArray = $.grep(pathArray,function(n){ return(n) });
      return pathArray[pathArray.length - 1];
    }

    function clickButton(name) {
      var button = $(name)[0];
      if(button) {
        button.click();
      }
    }
    // <<<<<<<<<<<<<HELPER FUNCS<<<<<<<<<<<<<<
  };

  $(document).ready(ready);
  $(document).on('page:load', ready);


})();





